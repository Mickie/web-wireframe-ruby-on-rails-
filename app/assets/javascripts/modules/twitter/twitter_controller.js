var NORMAL_TWEET_RELOAD_SCHEDULE = 20000;
var DELAYED_TWEET_RELOAD_SCHEDULE = 60000;

var TwitterController = function(aTwitterView, aFanzonePostsController)
{
  this.myTwitterView = aTwitterView;
  this.myFanzonePostsController = aFanzonePostsController;
  
  this.myTwitterInviteDialog = new TwitterInviteDialog();
  this.myHashTags = {};
  this.myNotTags = {};
  this.myMaxTweets = 0;
  this.myNewTweets = new Array();
  this.myFullyLoadedFlag = false;
  this.myTwitterSearch = new TwitterSearch(this);
  this.myRefreshTweetsInterval;

  this.initialize = function( aHashTags, aNotTags, aMaxTweets )
  {
    this.myHashTags = aHashTags;
    this.myNotTags = aNotTags;
    this.myMaxTweets = aMaxTweets;

    this.myTwitterSearch.getLatestTweetsForTerm(this.myHashTags, this.myNotTags, this.myMaxTweets);
  }

  this.scheduleMoreTweetsToLoad = function( aTimerDuration )
  {
    clearTimeout(this.myRefreshTweetsInterval);
    this.myRefreshTweetsInterval = setTimeout(createDelegate(this.myTwitterSearch, this.myTwitterSearch.grabMoreTweets), aTimerDuration);
  };
  
  this.reset = function()
  {
    clearTimeout(this.myRefreshTweetsInterval);
    this.myNewTweets = new Array();
    this.myFullyLoadedFlag = false;
    this.myTwitterSearch.abort();
  };

  this.chopOffOldestTweetsSoWeShowOnlyTheLatest = function()
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
    if (this.myNewTweets.length > this.myMaxTweets)
    {
      this.myNewTweets = this.myNewTweets.slice(this.myNewTweets.length - this.myMaxTweets);    
    }
  };

  this.onNewTweet = function(anIndex, aTweet)
  {
    if(this.myFullyLoadedFlag)
    {
      this.myNewTweets.push(aTweet);
      this.myTwitterView.showNewTweetsAlert( this.myNewTweets.length );
    }
    else
    {
      var theCount = this.myTwitterView.showInitialTweetAndGetCount(aTweet)
      
      if ( theCount >= this.myMaxTweets )
      {
        this.myFullyLoadedFlag = true;
        this.scheduleMoreTweetsToLoad(NORMAL_TWEET_RELOAD_SCHEDULE);    
      }
      updateTimestamps();
    }

  };
  
  this.onSuccess = function()
  {
    $("#tweetError").slideUp(600);
    this.scheduleMoreTweetsToLoad(NORMAL_TWEET_RELOAD_SCHEDULE);   
  };

  this.onError = function(aMessage)
  {
    $("#tweetError").slideDown(600);
    this.scheduleMoreTweetsToLoad(DELAYED_TWEET_RELOAD_SCHEDULE);
  };

  this.onShowNewTweets = function()
  {
    trackEvent("Twitter", "show_new_tweets", undefined, this.myNewTweets.length);    
    $(this.myNewTweetDivSelector).slideUp(600);
    this.chopOffOldestTweetsSoWeShowOnlyTheLatest();
    $.each(this.myNewTweets, createDelegate(this, this.showTweet));
    this.myNewTweets = new Array();
  };

  this.onReplyTo = function(e)
  {
    var theTweetId = $(e.target).attr("data-tweet-id");
    var theUser = $(e.target).attr("data-user");

    this.myFanzonePostsController.updatePostForm(true, "@" + theUser + " " + this.myTwitterView.myHashTags, theTweetId);
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

    var theMessage = "@" + theUser + ", I've got a conversation going about this on my @FanzoFans fanzone, interested? " + this.myTwitterView.myHashTags;
    this.myTwitterInviteDialog.showDialog( theMessage, theTweetId );
    trackEvent("Twitter", "invite_click");    
  };
  
   
}
