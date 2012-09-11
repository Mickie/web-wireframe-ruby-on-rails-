var DELAYED_TWEET_RELOAD_FACTOR = 3;

var TwitterController = function(aTwitterView, aFanzonePostsController)
{
  this.NORMAL_TWEET_DISPLAY_SCHEDULE = 1000;

  this.myTwitterView = aTwitterView;
  this.myFanzonePostsController = aFanzonePostsController;
  
  this.myTwitterInviteDialog = new TwitterInviteDialog();
  this.myHashTags = {};
  this.myNotTags = {};
  this.myMaxTweets = 0;
  this.myNewTweets = new Array();
  this.myFullyLoadedFlag = false;
  this.myTwitterSearch = new TwitterSearch(this);
  this.myRefreshTweetsTimeout;
  this.myShowNextTweetTimeout;
  this.myPausedFlag = false;

  this.myNormalTweetReloadSchedule;
  this.myDelayedTweetReloadSchedule;
  
  this.initialize = function( aHashTags, aNotTags, aMaxTweets )
  {
    this.myHashTags = aHashTags;
    this.myNotTags = aNotTags;
    this.myMaxTweets = aMaxTweets;
    
    this.myNormalTweetReloadSchedule = this.myMaxTweets * this.NORMAL_TWEET_DISPLAY_SCHEDULE;
    this.myDelayedTweetReloadSchedule = this.myNormalTweetReloadSchedule * DELAYED_TWEET_RELOAD_FACTOR;

    this.myTwitterSearch.getLatestTweetsForTerm(this.myHashTags, this.myNotTags, this.myMaxTweets);
  }
  
  this.pause = function()
  {
    this.myPausedFlag = true;
    clearTimeout(this.myShowNextTweetTimeout);
  }
  
  this.play = function()
  {
    this.myPausedFlag = false;
    clearTimeout(this.myShowNextTweetTimeout);
    this.myShowNextTweetTimeout = setTimeout(createDelegate(this, this.showNextTweet), this.NORMAL_TWEET_DISPLAY_SCHEDULE);
  }

  this.scheduleMoreTweetsToLoad = function( aTimerDuration )
  {
    clearTimeout(this.myRefreshTweetsTimeout);
    this.myRefreshTweetsTimeout = setTimeout(createDelegate(this.myTwitterSearch, this.myTwitterSearch.grabMoreTweets), aTimerDuration);
  };
  
  this.reset = function()
  {
    clearTimeout(this.myRefreshTweetsTimeout);
    clearTimeout(this.myShowNextTweetTimeout);
    this.myNewTweets = new Array();
    this.myFullyLoadedFlag = false;
    this.myTwitterSearch.abort();
  };

  this.chopOffOldestTweetsSoWeShowOnlyTheLatest = function()
  {
    if (this.myNewTweets.length > this.myMaxTweets)
    {
      this.myNewTweets = this.myNewTweets.slice(this.myNewTweets.length - this.myMaxTweets);    
    }
  };

  this.sortNewTweets = function()
  {
    this.myNewTweets.sort(function(a,b)
    {
      if (a.created_at == b.created_at)
      {
        return 0;
      }
      
      var theFirstDate = new Date(a.created_at);
      var theSecondDate = new Date(b.created_at);
      return theFirstDate > theSecondDate ? 1 : -1;
    });
  }
  
  this.onNewTweets = function( anArrayOfTweets )
  {
    this.myNewTweets = this.myNewTweets.concat(anArrayOfTweets);
    this.sortNewTweets();
    this.chopOffOldestTweetsSoWeShowOnlyTheLatest();
    
    if (this.myNewTweets.length > 0)
    {
      if (this.myPausedFlag)
      {
        this.myTwitterView.showNewTweetsAlert( this.myNewTweets.length );
      }
      else if (this.myTwitterView.isTweetDisplayFull())
      {
        this.play();
      }
      else
      {
        while( this.myNewTweets.length > 0 && !this.myTwitterView.isTweetDisplayFull())
        {
          this.sendNextTweetToView();
        }
      }
    }
  }
  
  this.sendNextTweetToView = function()
  {
    var theTweet = this.myNewTweets.shift();
    this.myTwitterView.showTweet(theTweet);
  }

  this.showNextTweet = function()
  {
    if(!this.myPausedFlag && this.myNewTweets.length > 0)
    {
      this.sendNextTweetToView();
      this.play();
    }
  }
  
  this.onSuccess = function()
  {
    $("#tweetError").slideUp(600);
    this.scheduleMoreTweetsToLoad(this.myNormalTweetReloadSchedule);   
  };

  this.onError = function(aMessage)
  {
    $("#tweetError").slideDown(600);
    this.scheduleMoreTweetsToLoad(this.myDelayedTweetReloadSchedule);
  };

  this.onReplyTo = function(e)
  {
    var theTweetId = $(e.target).attr("data-tweet-id");
    var theUser = $(e.target).attr("data-user");

    this.myFanzonePostsController.updatePostForm(true, "@" + theUser + " " + this.myHashTags, theTweetId);
    $("body").animate({scrollTop:0}, 400);
    trackEvent("Twitter", "reply_click");    
  };
  
  this.onRetweet = function(e)
  {
    var theTweetId = $(e.target).attr("data-tweet-id");
    var theUser = $(e.target).attr("data-user");
    var theTweetText = $(e.target).attr("data-tweet-text");

    this.myFanzonePostsController.updatePostForm(true, "RT @" + theUser + ": " + theTweetText, "", theTweetId);
    $("body").animate({scrollTop:0}, 400);
    trackEvent("Twitter", "retweet_click");    
  };
  
  this.onInvite = function(e)
  {
    var theTweetId = $(e.target).attr("data-tweet-id");
    var theUser = $(e.target).attr("data-user");

    var theMessage = "@" + theUser + ", I've got a conversation going about this on my @FanzoFans fanzone, interested? " + this.myHashTags;
    this.myTwitterInviteDialog.showDialog( theMessage, theTweetId );
    trackEvent("Twitter", "invite_click");    
  };
  
   
}
