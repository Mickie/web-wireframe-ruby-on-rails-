var InstagramSearch = function()
{
  this.myMediaResponseCount = 0;
  this.myCompleteCallback;
  this.myMedia = [];
  this.myTags;
  this.myAbortFlag = false;
  
  this.loadMediaForTags = function( anArrayOfTags, aCompleteCallback )
  {
    this.myCompleteCallback = aCompleteCallback;
    this.myTags = anArrayOfTags;

    if (!this.myTags || this.myTags.length == 0)
    {
      this.myCompleteCallback([]);
    }
    
    this.myMediaResponseCount = 0;
    for (var i=0; i < this.myTags.length; i++) 
    {
      this.getMediaForTag(this.myTags[i].name);
    };
  };
  
  this.abort = function()
  {
    this.myCompleteCallback = null;
    this.myAbortFlag = true;
  }
  
  this.getMediaForTag = function( aTag )
  {
    $.getJSON("/instagram_proxy/media_for_tag?tag=" + escape(aTag),
              createExtendedDelegate(this, this.onGetMediaForTagComplete, [aTag]));
  };
  
  this.onGetMediaForTagComplete = function(aResult, aTextStatus, aJQXHR, aTag)
  {
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.myMedia = this.myMedia.concat(aResult.data);
    
    this.myMediaResponseCount++;
    if (this.myMediaResponseCount == this.myTags.length)
    {
      this.myCompleteCallback(this.myMedia);
    }
  };
}
