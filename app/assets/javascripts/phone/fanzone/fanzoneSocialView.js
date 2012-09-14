var FanzoneSocialView = function()
{
  this.myTailgateModel = null;
  this.myTwitterView = null;
  this.myFanzoneScroller = null;
  
  this.render = function( aTailgateModel, aPostsController, aScroller )
  {
    if (this.myTailgateModel && this.myTailgateModel.id == aTailgateModel.id)
    {
      return;
    }

    this.myFanzoneScroller = aScroller;
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

  }
  
  this.onNewTweetShown = function()
  {
    this.myFanzoneScroller.refresh();
  }
  
  this.cleanup = function()
  {
    this.myTwitterView.reset();
    $("#phoneFanzoneContent #tweets").empty();
  }
  
}
