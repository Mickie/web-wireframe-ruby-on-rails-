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
      $(this.myTweetDivSelector).append(this.generateTweetDiv(aTweet));
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
    $(this.myTweetDivSelector).prepend(this.generateTweetDiv(aTweet));
    $(theNewDivSelector).slideDown(600, createDelegate(this, this.onAddComplete));
  };
  
  this.onAddComplete = function()
  {
    $(".tweet:last").remove();
  };
  
  this.generateTweetDiv = function(aTweet)
  {
    return $("#template").clone().render(aTweet, this.getTweetDirective());
  };
  
  this.getTweetDirective = function()
  {
    return {
      ".@id" : "id_str",
      "img.twitterAvatar@src" : "profile_image_url",
      "span.twitterName" : "from_user_name",
      "span.twitterText" : function(anItem)
      {
        var theText = anItem.context.text;
        var theUrls = anItem.context.entities.urls;
        for(var i=0,j=theUrls.length; i<j; i++)
        {
          var theUrlData = theUrls[i];
          var theAnchor = "<a href='" + theUrlData.url + "' target='_blank'>" + theUrlData.display_url + "</a>";
          theText = theText.replace(theUrlData.url, theAnchor);
        }
        return theText;
      },
      "div.timestamp" : function(anItem)
      {
        var theTweetDate = new Date( anItem.context.created_at );
        return theTweetDate.toDateString() + " " + theTweetDate.toLocaleTimeString()
      },
      "a#reply@href" : function(anItem)
      {
        var theId = anItem.context.id_str;
        var theUser = anItem.context.from_user;
        return "javascript:myTwitterView.onReplyTo('" + theId + "', '@" + theUser + "')";
      },
      "a#retweet@href" : function(anItem)
      {
        var theId = anItem.context.id_str;
        return "javascript:myTwitterView.onRetweet('" + theId + "')";
      },
      "a#favorite@href" : function(anItem)
      {
        var theId = anItem.context.id_str;
        return "javascript:myTwitterView.onFavorite('" + theId + "')";
      },
      "div.alert > p@id" : function(anItem)
      {
        var theId = anItem.context.id_str;
        return theId + "_alertText";
      }
    }
  };
  
  this.showTweetDialog = function( aDefaultText )
  {
    $("#tweetText").val(aDefaultText);
    $(".modal").modal("hide");
    $("#myTweetModal").modal("show"); 
  };

  this.onReplyTo = function( aTweetId, aUser)
  {
    this.showTweetDialog(aUser + " " + this.myHashTags);
    $("#sendTweetButton").click(createDelegate(this, this.onSendReply)).attr("reply_id", aTweetId);    
  };
  
  this.onSendTweet = function( e )
  {
    var theTweetText = $("#tweetText").val();
    $.post( "/twitter_proxy/update_status", 
            {statusText : theTweetText }, 
            createDelegate(this, this.onTweetComplete), 
            "json" );  
    $("#myTweetModal").modal("hide"); 
  };
  
  this.onSendReply = function( e )
  {
    var theReplyId = $("#sendTweetButton").attr("reply_id");
    var theTweetText = $("#tweetText").val();
    $.post( "/twitter_proxy/update_status", 
            {statusText : theTweetText, replyId : theReplyId }, 
            createDelegate(this, this.onTweetComplete), 
            "json" );  
  };
  
  this.onTweetComplete = function(aResponse)
  {
    $("#tweetSuccessAlert").slideDown(600);
    setTimeout(function(){$("#tweetSuccessAlert").slideUp(600);}, 5000);
  };
    
  this.onRetweet = function( aTweetId )
  {
    $.post("/twitter_proxy/retweet", { tweetId : aTweetId }, createDelegate(this, this.onRetweetComplete), "json"); 
  };
  
  this.onRetweetComplete = function(aResponse)
  {
    if (aResponse)
    {
      this.showAlertWithHtml( aResponse.retweeted_status.id_str, "<strong>Success!</strong><br/>Your retweet succeeded");
    }
  };
  
  this.onFavorite = function( aTweetId )
  {
    $.post("/twitter_proxy/favorite", { favoriteId : aTweetId }, createDelegate(this, this.onFavoriteComplete), "json"); 
  };
  
  this.onFavoriteComplete = function(aResponse)
  {
    if (aResponse)
    {
      this.showAlertWithHtml( aResponse.id_str, "<strong>Success!</strong><br/>You added a Favorite");
    }
  };
  
  this.showAlertWithHtml = function( anId, anHtml)
  {
    var theAlertSelector = "#" + anId + " div.alert";
    $(theAlertSelector).slideDown(600);
    setTimeout(function(){$(theAlertSelector).slideUp(600);}, 5000);
    
    var theTextSelector = "#" + anId + "_alertText";
    $(theTextSelector).html( anHtml );
  }
  
}
