var FanzoneMediaView = function()
{
  this.myTailgateModel = null;
  this.myMediaSlider = null;
  this.myAbortFlag = false;
  
  this.render = function( aTailgateModel )
  {
    if (this.myTailgateModel && this.myTailgateModel.id == aTailgateModel.id)
    {
      return;
    }
    
    this.myAbortFlag = false;
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
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.myMediaSlider =  MediaSlider.create();
    this.myMediaSlider.createSlider( this.myTailgateModel.team.short_name,
                                     "Football", 
                                     this.myTailgateModel.topic_tags.split(","),
                                     aResult,
                                     this.myTailgateModel.team.id);
  }
  
  this.cleanup = function()
  {
    this.myAbortFlag = true;
    if (this.myMediaSlider)
    {
      this.myMediaSlider.reset();
    }
  }
  
}
