var FanzoneSocialView = function()
{
  this.myTailgateModel = null;
  this.myTwitterView = null;
  
  this.render = function( aTailgateModel, aPostsController )
  {
    this.myTailgateModel = aTailgateModel;
    this.myTwitterView = TwitterView.create(15,
                                            "tweets",
                                            "newTweets",
                                            aPostsController
                                            );

    this.myTwitterView.startLoadingTweets( this.myTailgateModel.topic_tags.split(","),
                                          this.myTailgateModel.not_tags.split(",")
                                          );

  }
  
  this.cleanup = function()
  {
    this.myTwitterView.reset();
  }
  
}
