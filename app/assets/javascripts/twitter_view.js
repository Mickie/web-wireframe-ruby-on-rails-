var MAX_TWEETS = 15;

var TwitterView = function(anArrayOfHashTags, aMaxTweets, aTweetDivId, aNewTweetDivId)
{
  this.myMaxTweets = aMaxTweets ? aMaxTweets : MAX_TWEETS;
  this.myTweetDivSelector = aTweetDivId ? "div#" + aTweetDivId : "div#tweets";
  this.myNewTweetDivSelector = aNewTweetDivId ? "div#" + aNewTweetDivId : "div#newTweets";
  this.myHashTags = anArrayOfHashTags;
  this.myNewTweets = new Array();
  this.myFullyLoadedFlag = false;
  this.myTwitterSearch = null;

  this.startLoadingTweets = function()
  {
    this.myTwitterSearch = new TwitterSearch(createDelegate(this, this.onNewTweet), createDelegate(this, this.onError));
    this.myTwitterSearch.getLatestTweetsForTerm(this.myHashTags.join(" OR "));
    window.setInterval(createDelegate(this.myTwitterSearch, this.myTwitterSearch.grabMoreTweets), 5000);
  };

  this.onNewTweet = function(anIndex, aTweet)
  {
    var theNewDivSelector = "#" + aTweet.id_str;
    if(this.myFullyLoadedFlag)
    {
      this.myNewTweets.unshift(aTweet);
      this.showNewTweetsAlert();
    }
    else
    {
      $(this.myTweetDivSelector).append(this.getTweetMarkup(aTweet));
      $(theNewDivSelector).slideDown(200);
      
      if ($(this.myTweetDivSelector).children().length > this.myMaxTweets)
      {
        this.myFullyLoadedFlag = true;
      }
    }

  };

  this.onError = function(aMessage)
  {
    $( this.myTweetDivSelector ).html( "<p>" + aMessage + "</p>" )
  };

  this.showNewTweetsAlert = function()
  {
    $(this.myNewTweetDivSelector + " > p").html("<strong>" + this.myNewTweets.length + "</strong> new Tweets!");
    $(this.myNewTweetDivSelector).slideDown(600).click(createDelegate(this, this.showNewTweets));
  };

  this.showNewTweets = function()
  {
    $(this.myNewTweetDivSelector).slideUp(600);
    $.each(this.myNewTweets, createDelegate(this, this.showTweet));
    this.myNewTweets = new Array();
  };

  this.showTweet = function(i, aTweet)
  {
    if(i > this.myMaxTweets)
    {
      return;
    }

    var theNewDivSelector = "#" + aTweet.id_str;
    $(this.myTweetDivSelector).prepend(this.getTweetMarkup(aTweet));
    $(theNewDivSelector).slideDown(600, createDelegate(this, this.onAddComplete));
  };
  
  this.onAddComplete = function()
  {
    $(".tweet:last").remove();
  };
  
  
  this.getTweetMarkup = function( aTweet )
  {
    var theTweetDate = new Date( aTweet.created_at );

    return "<div id='" + aTweet.id_str + "' class='tweet well' style='display:none'><img src='"
           + aTweet.profile_image_url
           + "' style='float:left' width='48px' height='48px'></img> <strong>"
           + aTweet.from_user_name
           + ": </strong>"
           + aTweet.text
           + "<div class='tweetMenu'><div class='timestamp'>"
           + theTweetDate.toDateString()
           + " "
           + theTweetDate.toLocaleTimeString()
           + "</div>";
           
           // + this.getTweetMenuMarkup(aTweet);
  }
  
  this.getTweetMenuMarkup = function( aTweet )
  {
    return "<a href=\"javascript:replyTo('"
           + aTweet.id_str
           + "', '@" 
           + aTweet.from_user 
           + "')\"><img src='img/reply.png'></img>Reply</a>"
           + "| <a href=\"javascript:retweet('"
           + aTweet.id_str
           + "')\"><img src='img/retweet.png'></img>Retweet</a>"
           + "| <a href=\"javascript:favorite('"
           + aTweet.id_str
           + "')\"><img src='img/favorite.png'></img>Favorite</a>"
           + "</div><div class='alert alert-info fade in' style='display:none'>"
           + "<a class='close' data-dismiss='alert' href='#'>×</a><p id='" 
           + aTweet.id_str 
           + "_alertText'><strong>Success!</strong></p></div></div>"
  }
  
}
