var FanzonePostView = function( aPostsSelector )
{
  var POST_CONTENT_COOKIE = "FanzonePostView.post_content";
  
  this.myPostsSelector = aPostsSelector;
  this.myQuickTweetsView = new QuickTweetView(aPostsSelector, this);
  
  this.initialize = function( aSportId, aHashTagString )
  {
    this.loadSavedDataIntoForm();
    this.myQuickTweetsView.initialize( aSportId, aHashTagString);
    UserManager.get().addObserver(this);
    this.setupFormListeners();
  }
  
  this.setupFormListeners = function()
  {
    $(this.myPostsSelector).on('ajax:before', ".new_comment", createDelegate( this, this.checkStatus ) );
    $(this.myPostsSelector).on('click', ".vote_up i:not(.disabled)", createDelegate( this, this.submitUpVote ) );
    $(this.myPostsSelector).on('click', ".vote_down i:not(.disabled)", createDelegate( this, this.submitDownVote ) );
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
  

  this.checkStatus = function(e)
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

var mySingletonFanzonePostView;
FanzonePostView.create = function(aPostsDivSelector)
{
  if (mySingletonFanzonePostView)
  {
    return mySingletonFanzonePostView;
  }
  
  mySingletonFanzonePostView = new FanzonePostView(aPostsDivSelector);
  return mySingletonFanzonePostView;
}
