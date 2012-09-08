var FanzoneMediaView = function()
{
  this.myTailgateModel = null;
  this.myMediaSlider = null;
  
  this.render = function( aTailgateModel )
  {
    this.myTailgateModel = aTailgateModel;
    this.loadTags();
  }
  
  this.loadTags = function()
  {
    $.getJSON("/instagram_proxy/find_tags_for_fanzone?fanzone_id=" + escape(this.myTailgateModel.id),
              createDelegate(this, this.onGetTagsComplete));
  }
  
  this.onGetTagsComplete = function(aResult)
  {
    this.myMediaSlider =  MediaSlider.create();
    this.myMediaSlider.createSlider( this.myTailgateModel.team.short_name,
                                     "Football", 
                                     this.myTailgateModel.topic_tags.split(","),
                                     aResult,
                                     this.myTailgateModel.team.id);
  }
  
  this.cleanup = function()
  {
    this.myMediaSlider.reset();
  }
  
}
