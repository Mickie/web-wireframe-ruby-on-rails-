var FanzoneSocialView = function()
{
  this.myTailgateModel = null;
  this.myTwitterView = null;
  this.myTweetsScroller = null;
  
  this.render = function( aTailgateModel, aPostsController )
  {
    if (this.myTailgateModel && this.myTailgateModel.id == aTailgateModel.id)
    {
      return;
    }

    this.myTailgateModel = aTailgateModel;
    this.myTwitterView = TwitterView.create(15,
                                            "tweets",
                                            "newTweets",
                                            aPostsController
                                            );

    this.myTwitterView.startLoadingTweets( this.myTailgateModel.topic_tags.split(","),
                                          this.myTailgateModel.not_tags.split(","),
                                          this
                                          );
    this.setupTweetsScroller();
  }
  
  this.setupTweetsScroller = function()
  {
    this.myTweetsScroller = new iScroll("tweetScroller",
                                        {
                                          hScroll: false,
                                          hScrollbar: false,
                                          onTouchEnd: scrollWindowToTopOnTouchEnd
                                        });
    $("#postsAndComments").on("touchmove", "#tweetScroller", function (e) { e.preventDefault(); });
  }
  
  this.cleanupTweetsScroller = function()
  {
    $("#postsAndComments").off("touchmove", "#tweetScroller");
    if (this.myTweetsScroller)
    {
      this.myTweetsScroller.destroy()
      this.myTweetsScroller = null;
    }
  }

  this.onNewTweetShown = function()
  {
    this.myTweetsScroller.refresh();
  }
  
  this.cleanup = function()
  {
    this.cleanupTweetsScroller();
    if (this.myTwitterView)
    {
      this.myTwitterView.reset();
    }
    $("#phoneFanzoneContent #tweets").empty();
  }
  
}
