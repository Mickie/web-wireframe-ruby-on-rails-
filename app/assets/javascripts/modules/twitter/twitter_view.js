
var TwitterView = function( anArrayOfHashTags, 
                            anArrayOfNotTags,
                            aMaxTweets, 
                            aTweetDivId, 
                            aNewTweetDivId,
                            aControlsDivId, 
                            aConnectedToTwitterFlag,
                            aUserId,
                            aSportId,
                            aTwitterViewVariableName)
{
  this.myHashTags = anArrayOfHashTags;
  this.myNotTags = anArrayOfNotTags;
  this.myMaxTweets = aMaxTweets;
  this.myTweetDivSelector = "#" + aTweetDivId;
  this.myNewTweetDivSelector = "#" + aNewTweetDivId;
  this.myControlsDivSelector = "#" + aControlsDivId;
  this.myConnectedToTwitterFlag = aConnectedToTwitterFlag;
  this.myUserId = aUserId;
  this.mySportId = aSportId;
  this.myTwitterViewVariableName = aTwitterViewVariableName;
  
  this.myNewTweets = new Array();
  this.myFullyLoadedFlag = false;
  this.myTwitterSearch = null;
  this.myTwitterController = new TwitterController(this);
  this.myRefreshTweetsInterval;

  var theCurrentPostVal = getCookie("#postForm #post_content");
  if (theCurrentPostVal)
  {
    setCookie("#postForm #post_content", "", 0);
    $("#postForm #post_content").val(theCurrentPostVal);
  }

  this.isLoggedIn = function()
  {
    return this.myUserId > 0;
  }
  
  this.isConnectedToTwitter = function()
  {
    return this.myConnectedToTwitterFlag;
  }

  this.startLoadingTweets = function()
  {
    this.myTwitterSearch = new TwitterSearch(createDelegate(this, this.onNewTweet), createDelegate(this, this.onError));
    this.myTwitterSearch.getLatestTweetsForTerm(this.myHashTags, this.myNotTags, this.myMaxTweets);
    this.initializeButtons();
    
    this.myRefreshTweetsInterval = setInterval(createDelegate(this.myTwitterSearch, this.myTwitterSearch.grabMoreTweets), 50000);
  };
  
  this.destroy = function()
  {
    clearInterval(this.myRefreshTweetsInterval);
  };
  
  if (this.isConnectedToTwitter())
  {
    this.onReplyTo = createDelegate(this.myTwitterController, this.myTwitterController.onReplyTo);
    this.onRetweet = createDelegate(this.myTwitterController, this.myTwitterController.onRetweet);
    this.onFavorite = createDelegate(this.myTwitterController, this.myTwitterController.onFavorite);

    this.updatePostForm = function( aDefaultText, aReplyId, aRetweetId )
    {
      $(this.myControlsDivSelector + " #post_content").val(aDefaultText);
      $(this.myControlsDivSelector + " #post_twitter_reply_id").val(aReplyId ? aReplyId : "");
      $(this.myControlsDivSelector + " #post_twitter_retweet_id").val(aRetweetId ? aRetweetId : "");
    };
  }
  else
  {
    this.saveData = function()
    {
      var theCurrentPostVal = $("#postForm #post_content").val();
      setCookie("#postForm #post_content", theCurrentPostVal, 1);
    };
    
    this.disallowIfPostingToTwitter = function()
    {
      var theTwitterFlag = $("#postForm #post_twitter_flag").is(':checked');
      if (theTwitterFlag)
      {
        this.saveData()
        $("#myConnectTwitterModal").modal("show"); 
        return false;
      }
      else
      {
        return true;
      }
    };

    this.handleDisconnectStatus = function()
    {
      if (this.isLoggedIn())
      {
        return this.disallowIfPostingToTwitter();
      }
      else
      {
        this.saveData();
        $("#myLoginModal").modal("show");
        return false; 
      }
    };
    
    this.onReplyTo = this.handleDisconnectStatus;
    this.onRetweet = this.handleDisconnectStatus;
    this.onFavorite = this.handleDisconnectStatus;
    this.updatePostForm = this.handleDisconnectStatus;
    
    $("#postForm #add_post").live('click', createDelegate(this, this.handleDisconnectStatus ) );
  }
  
  
  this.initializeButtons = function()
  {
    this.myTwitterController.loadButtonData(this.mySportId, createDelegate(this, this.onButtonDataLoaded));
  };
  
  this.onButtonDataLoaded = function()
  {
    this.myTwitterController.addQuickTweetButtons( $( this.myControlsDivSelector + " ul.dropdown-menu") );
    
    $( this.myControlsDivSelector + " a" ).each( createDelegate(this.myTwitterController, 
                                                                this.myTwitterController.addQuickTweetClick ));
  };
  
  
  this.onNewTweet = function(anIndex, aTweet)
  {
    if(this.myFullyLoadedFlag)
    {
      this.myNewTweets.push(aTweet);
      this.showNewTweetsAlert();
    }
    else
    {
      var theNewDivSelector = "#" + aTweet.id_str;
      $(this.myTweetDivSelector).append(this.generateTweetDiv(aTweet));
      $(theNewDivSelector).slideDown(200);
      
      var theExtraTweetTemplateElement = 1;
      if ($(this.myTweetDivSelector).children().length >= this.myMaxTweets + theExtraTweetTemplateElement)
      {
        this.myFullyLoadedFlag = true;
      }
    }

  };

  this.onError = function(aMessage)
  {
    console.log("Error getting tweets: " + aMessage);
  };
  
  this.showNewTweetsAlert = function()
  {
    $(this.myNewTweetDivSelector + " > p").html("<strong>" + this.myNewTweets.length + "</strong> new Tweets!");
    $(this.myNewTweetDivSelector).slideDown(600).click(createDelegate(this, this.showNewTweets));
  };

  this.showNewTweets = function()
  {
    $(this.myNewTweetDivSelector).slideUp(600);
    this.chopOffOldestTweetsSoWeShowOnlyTheLatest();
    $.each(this.myNewTweets, createDelegate(this, this.showTweet));
    this.myNewTweets = new Array();
  };

  this.chopOffOldestTweetsSoWeShowOnlyTheLatest = function()
  {
    if (this.myNewTweets.length > this.myMaxTweets)
    {
      this.myNewTweets = this.myNewTweets.slice(this.myNewTweets.length - this.myMaxTweets);    
    }
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
    var theDiv = $("#template").clone().render(aTweet, this.getTweetDirective());
    theDiv.find(".timestamp").timeago();
    return theDiv;
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
      "a#reply@href" : function(anItem)
      {
        var theId = anItem.context.id_str;
        var theUser = anItem.context.from_user;
        return "javascript:" + theThis.myTwitterViewVariableName + ".onReplyTo('" + theId + "', '@" + theUser + "')";
      },
      "a#retweet@href" : function(anItem)
      {
        var theId = anItem.context.id_str;
        var theText = anItem.context.text;
        return "javascript:" + theThis.myTwitterViewVariableName + ".onRetweet('" + theId + "', \"" + theText.escapeQuotes() + "\")";
      },
      "a#favorite@href" : function(anItem)
      {
        var theId = anItem.context.id_str;
        return "javascript:" + theThis.myTwitterViewVariableName + ".onFavorite('" + theId + "')";
      },
      "div.alert > p@id" : function(anItem)
      {
        var theId = anItem.context.id_str;
        return theId + "_alertText";
      }
    }
  };
  
  this.onTweetComplete = function(aResponse, aSource)
  {
    $(this.myControlsDivSelector + " textarea").val(this.myHashTags);
    $("#tweetSuccessAlert div.messageHolder").append('<p><strong>Success!</strong> Your ' + aSource + ' status was updated</p>');
    $("#tweetSuccessAlert").slideDown(600);
    setTimeout(createDelegate(this, this.hideTweetSuccess), 5000);
  };
  
  this.hideTweetSuccess = function()
  {
    $("#tweetSuccessAlert").slideUp(600, createDelegate(this, this.onHideComplete));
  }
  
  this.onHideComplete = function()
  {
    $("#tweetSuccessAlert div.messageHolder").empty();    
  }
    
  this.onRetweetComplete = function(aResponse)
  {
    if (aResponse)
    {
      this.showAlertWithHtml( aResponse.retweeted_status.id_str, "<strong>Success!</strong><br/>Your retweet succeeded");
    }
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

var myCurrentTwitterViews = {};
TwitterView.create = function(anArrayOfHashTags, 
                              anArrayOfNotTags,
                              aMaxTweets, 
                              aTweetDivId, 
                              aNewTweetDivId,
                              aControlsDivId, 
                              aConnectedToTwitterFlag,
                              aUserId,
                              aSportId,
                              aTwitterViewVariableName)
{
  if (myCurrentTwitterViews[aTwitterViewVariableName])
  {
    myCurrentTwitterViews[aTwitterViewVariableName].destroy();
  }
  myCurrentTwitterViews[aTwitterViewVariableName] = new TwitterView( anArrayOfHashTags, 
                                                                    anArrayOfNotTags,
                                                                    aMaxTweets, 
                                                                    aTweetDivId, 
                                                                    aNewTweetDivId,
                                                                    aControlsDivId, 
                                                                    aConnectedToTwitterFlag,
                                                                    aUserId,
                                                                    aSportId,
                                                                    aTwitterViewVariableName);
  
  return myCurrentTwitterViews[aTwitterViewVariableName];
};
