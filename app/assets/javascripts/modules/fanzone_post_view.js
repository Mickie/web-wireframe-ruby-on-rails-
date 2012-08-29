var FanzonePostView = function( aPostsSelector )
{
  this.myPostsSelector = aPostsSelector;
  this.myQuickTweetsView = new QuickTweetView(aPostsSelector, this);
  
  this.initialize = function( aSportId, aHashTagString )
  {
    this.myQuickTweetsView.initialize( aSportId, aHashTagString);
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
