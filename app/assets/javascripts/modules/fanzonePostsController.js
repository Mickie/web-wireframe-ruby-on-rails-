var FanzonePostsController = function( aPostsSelector )
{
  var POST_CONTENT_COOKIE = "FanzonePostsController.post_content";
  
  this.myPostsSelector = aPostsSelector;
  this.myQuickTweetsView = new QuickTweetView(aPostsSelector, this);
  
  this.initialize = function( aSportId, aHashTagString )
  {
    this.loadSavedDataIntoForm();
    this.myQuickTweetsView.initialize( aSportId, aHashTagString);
    EventManager.get().addObserver("onShowConnectionModal", this);
    EventManager.get().addObserver("onCreatePostComplete", this);
    this.setupFormListeners();
  }
  
  this.setupFormListeners = function()
  {
    $(this.myPostsSelector).on('click', ".vote_up i:not(.disabled)", createDelegate( this, this.submitUpVote ) );
    $(this.myPostsSelector).on('click', ".vote_down i:not(.disabled)", createDelegate( this, this.submitDownVote ) );
    $(this.myPostsSelector).on('click', "#add_post", createDelegate(this, this.handleDisconnectStatus ) );
    $(this.myPostsSelector).on('click', ".comment_input", createDelegate(this, this.checkLoginStatus ) );
    $(this.myPostsSelector).on('click', "#post_content", createDelegate(this, this.checkLoginStatus ) );
    $(this.myPostsSelector).on('ajax:before', ".new_comment", createDelegate( this, this.checkLoginStatus ) );
    $(this.myPostsSelector).on('click', "#photo_picker", createDelegate(this, this.pickPhoto));
    $(this.myPostsSelector).on('change', "#post_photo_attributes_image", createDelegate(this, this.onPhotoPicked));
  }
  
  this.pickPhoto = function(e)
  {
    $(this.myPostsSelector).find("#post_photo_attributes_image").click();
  }
  
  this.onCreatePostComplete = function()
  {
    $("#postForm .video_container").hide();
    $("#postForm .image_container").hide();
    $("#postForm #post_content").val("");
    $("#postForm #post_video_id").val("");
    $("#postForm #post_image_url").val("");
    $("#postForm #post_twitter_reply_id").val("");
    $("#postForm #post_twitter_retweet_id").val("");
  }
  
  this.onPhotoPicked = function(e)
  {
    var theFiles = e.target.files;
    
    if (theFiles.length > 0)
    {
      var theUrl = "";
      if (window.webkitURL && window.webkitURL.createObjectURL)
      {
        var theUrl = window.webkitURL.createObjectURL(theFiles[0]);
      }
      else if (window.URL.createObjectURL && window.URL.createObjectURL)
      {
        var theUrl = window.URL.createObjectURL(theFiles[0]);
      }
  
      if (theUrl.length > 0)
      {
        thePostDiv = $(this.myPostsSelector);
        thePostDiv.find(".video_container").hide();
        thePostDiv.find(".image_container img").attr("src", theUrl);
        thePostDiv.find(".image_container").slideDown(600);
        thePostDiv.find("#photo_picker").hide();
      }
    }
    else
    {
      thePostDiv = $(this.myPostsSelector);
      thePostDiv.find(".image_container").hide();
      thePostDiv.find("#photo_picker").show();
    }
  }
  
  this.updatePostForm = function( aForceTwitterFlag, aDefaultText, aReplyId, aRetweetId )
  {
    thePostsContainer = $(this.myPostsSelector);
    if (aForceTwitterFlag)
    {
      thePostsContainer.find("#post_twitter_flag").prop("checked", true);
    }

    thePostsContainer.find("#post_content").val(aDefaultText);
    thePostsContainer.find("#post_twitter_reply_id").val(aReplyId ? aReplyId : "");
    thePostsContainer.find("#post_twitter_retweet_id").val(aRetweetId ? aRetweetId : "");
  };
  
  this.disallowIfPostingToTwitterAndNotConnected = function()
  {
    var theTwitterFlag = $(this.myPostsSelector).find("#post_twitter_flag").is(':checked');
    if (theTwitterFlag && !UserManager.get().isConnectedToTwitter())
    {
      trackEvent("Twitter", "not_connected_click");    
      UserManager.get().showTwitterModal()
      return false;
    }
    
    return true;
  };

  this.handleDisconnectStatus = function()
  {
    if (UserManager.get().isLoggedIn())
    {
      return this.disallowIfPostingToTwitterAndNotConnected();
    }

    UserManager.get().showFacebookModal();
    trackEvent("Facebook", "not_logged_in_click");    
    return false; 
  };

  this.checkLoginStatus = function(e)
  {
    if (!UserManager.get().isLoggedIn())
    {
      UserManager.get().showFacebookModal();
      return false;
    }
    
    return true;
  }
  
  this.submitVote = function(e)
  {
    if (UserManager.get().isLoggedIn())
    {
      $(e.target.parentElement).submit();
    }
    else
    {
      UserManager.get().showFacebookModal();
    }
  }
  
  this.submitUpVote = function(e)
  {
    this.submitVote(e);
  }
  
  this.submitDownVote = function(e)
  {
    if ($(e.target).hasClass('mine'))
    {
      return;
    }
    
    if (confirm("Mark this as spam or offensive?\n\nIt will be removed from your stream.\n\n"))
    {
      this.submitVote(e);
    }
    else
    {
      trackEvent("PostAndComments", "cancel_down_vote", $(e.target.parentElement).attr("id"));    
    }
    
  }
  
  this.onShowConnectionModal = function()
  {
    this.saveData();    
  }
  
  this.saveData = function()
  {
    var theCurrentPostVal = $(this.myPostsSelector).find("#post_content").val();
    setCookie(POST_CONTENT_COOKIE, theCurrentPostVal, 1);
  };

  this.loadSavedDataIntoForm = function()
  {
    var theCurrentPostVal = getCookie(POST_CONTENT_COOKIE);
    if (theCurrentPostVal)
    {
      setCookie(POST_CONTENT_COOKIE, "", 0);
      $(this.myPostsSelector).find("#post_content").val(theCurrentPostVal);
    }
  }
}

var mySingletonFanzonePostsController;
FanzonePostsController.create = function(aPostsDivSelector)
{
  if (mySingletonFanzonePostsController)
  {
    return mySingletonFanzonePostsController;
  }
  
  mySingletonFanzonePostsController = new FanzonePostsController(aPostsDivSelector);
  return mySingletonFanzonePostsController;
}
