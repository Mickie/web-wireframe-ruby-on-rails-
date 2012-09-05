
var TwitterView = function( aMaxTweets, 
                            aTweetDivId, 
                            aNewTweetDivId,
                            aFanzonePostsController)
{
  this.myMaxTweets = aMaxTweets;
  this.myTweetDivSelector = "#" + aTweetDivId;
  this.myNewTweetDivSelector = "#" + aNewTweetDivId;
  
  this.myTwitterController = new TwitterController(this, aFanzonePostsController);

  this.startLoadingTweets = function( anArrayOfHashTags, anArrayOfNotTags )
  {
    this.myTwitterController.initialize( anArrayOfHashTags, anArrayOfNotTags, this.myMaxTweets );

    $(this.myNewTweetDivSelector).click(createDelegate(this.myTwitterController, this.myTwitterController.onShowNewTweets));
  };
  
  this.reset = function()
  {
    this.myTwitterController.reset();
  };

  this.showCorrectModal = function()
  {
    if (UserManager.get().isLoggedIn())
    {
      trackEvent("Twitter", "not_connected_click");    
      UserManager.get().showTwitterModal();
    }
    else
    {
      trackEvent("Twitter", "not_logged_in_click");    
      UserManager.get().showFacebookModal();
    }
  };

  
  this.showNewTweetsAlert = function( aNumberOfNewTweets )
  {
    var theNoun = aNumberOfNewTweets > 1 ? "Tweets" : "Tweet";
    $(this.myNewTweetDivSelector + " > p").html("<strong>" + aNumberOfNewTweets + "</strong> new " + theNoun + "!");
    $(this.myNewTweetDivSelector).slideDown(600);
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
    updateTimestamps();
  };
  
  this.showInitialTweetAndGetCount = function( aTweet )
  {
    var theNewDivSelector = "#" + aTweet.id_str;
    $(this.myTweetDivSelector).append(this.generateTweetDiv(aTweet));
    $(theNewDivSelector).slideDown(200);
    
    return $(this.myTweetDivSelector).children().length;
  }
  
  this.onAddComplete = function()
  {
    $(".tweet:last").remove();
  };
  
  this.generateTweetDiv = function(aTweet)
  {
    try
    {
      var theDiv = $("#tweetTemplate").clone().render(aTweet, this.getTweetDirective());
      
      if (UserManager.get().isConnectedToTwitter())
      {
        theDiv.on("click", ".reply", createDelegate(this.myTwitterController, this.myTwitterController.onReplyTo) );
        theDiv.on("click", ".retweet", createDelegate(this.myTwitterController, this.myTwitterController.onRetweet) );
        theDiv.on("click", ".invite", createDelegate(this.myTwitterController, this.myTwitterController.onInvite) );
      }
      else
      {
        var theDelegate = createDelegate(this, this.showCorrectModal);
        theDiv.on("click", ".reply",  theDelegate);
        theDiv.on("click", ".retweet", theDelegate );
        theDiv.on("click", ".invite", theDelegate );
      }
      return theDiv;
    }
    catch(anError)
    {
      console.log(anError);
      return "<div></div>";    
    }
  };
  
  this.makeInlineUrlsLinks = function(aText, anArrayOfUrls)
  {
    var theText = aText;
    for(var i=0,j=anArrayOfUrls.length; i<j; i++)
    {
      var theUrlData = anArrayOfUrls[i];
      var theAnchor = "<a href='" + theUrlData.url + "' target='_blank'>" + theUrlData.display_url + "</a>";
      theText = theText.replace(theUrlData.url, theAnchor);
    }
    
    return theText;
  };
  
  this.getTweetDirective = function()
  {
    var theThis = this;
    return {
      ".@id" : "id_str",
      "img.twitterAvatar@src" : "profile_image_url",
      "div.twitterName" : "from_user_name",
      "span.twitterText" : function(anItem)
      {
        var theText = anItem.context.text;
        if (anItem.context.entities && anItem.context.entities.urls)
        {
          var theUrls = anItem.context.entities.urls;
          theText = theThis.makeInlineUrlsLinks(theText, theUrls);
        }
        return theText;
      },
      "div.timestamp" : function(anItem)
      {
        var theTweetDate = new Date( anItem.context.created_at );
        return theTweetDate.toDateString() + " " + theTweetDate.toLocaleTimeString();
      },
      "div.timestamp@title" : function(anItem)
      {
        var theTweetDate = new Date( anItem.context.created_at );
        return theTweetDate.toISOString();
      },
      ".reply@data-tweet-id" : "id_str",
      ".reply@data-user" : "from_user",
      ".retweet@data-tweet-id" : "id_str",
      ".retweet@data-user" : "from_user",
      ".retweet@data-tweet-text" : function(anItem)
      {
        var theText = anItem.context.text;
        return theText.escapeQuotes();
      },
      ".invite@data-tweet-id" : "id_str",
      ".invite@data-user" : "from_user",
      "div.alert > p@id" : function(anItem)
      {
        var theId = anItem.context.id_str;
        return theId + "_alertText";
      }
    }
  };
  
  this.onInviteComplete = function(aResponse)
  {
    if (aResponse)
    {
      this.showAlertWithHtml( aResponse.id_str, "<strong>Success!</strong><br/>Invitation sent");
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

var myCurrentTwitterViews = {};
TwitterView.create = function(aMaxTweets, 
                              aTweetDivId, 
                              aNewTweetDivId,
                              aFanzonePostsController, 
                              aUniqueId)
{
  if (myCurrentTwitterViews[aUniqueId])
  {
    myCurrentTwitterViews[aUniqueId].reset();
    return myCurrentTwitterViews[aUniqueId];
  }
  
  myCurrentTwitterViews[aUniqueId] = new TwitterView( aMaxTweets, 
                                                      aTweetDivId, 
                                                      aNewTweetDivId,
                                                      aFanzonePostsController);
  
  return myCurrentTwitterViews[aUniqueId];
};
