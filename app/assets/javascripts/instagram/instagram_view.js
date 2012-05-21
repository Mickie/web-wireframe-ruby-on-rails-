var InstagramView = function(aDivId)
{
  this.myContentDivSelector = "div#" + aDivId;
  this.myTeamId = "";
  this.myMediaLoadedCompleteCallback = null;
  
  this.startLoadingImagesForTeam = function( aTeamId, aCompleteCallback )
  {
    this.myMediaLoadedCompleteCallback = aCompleteCallback;
    this.myTeamId = aTeamId;
    $.getJSON("/instagram_proxy/find_tags.json?team_id=" + this.myTeamId, 
              createDelegate(this, this.onFindTagsComplete));
  };
  
  this.onFindTagsComplete = function(aResult)
  {
    for (var i=0; i < aResult.length; i++) 
    {
      var theTag = aResult[i];
      this.loadMediaForTag(theTag.name, this.myMediaLoadedCompleteCallback);
    };
  };
  
  this.loadMediaForTag = function( aTag, aCompleteCallback )
  {
    this.myMediaLoadedCompleteCallback = aCompleteCallback;
    $.getJSON("/instagram_proxy/media_for_tag?tag=" + escape(aTag),
              createExtendedDelegate(this, this.onMediaForTagComplete, [aTag]));
  };
  
  this.onMediaForTagComplete = function(aResult, aTextStatus, aJQXHR, aTag)
  {
    var theParentDiv = $(this.myContentDivSelector + " div.slides_container");
    for (var i=0; i < aResult.data.length; i++) 
    {
      theImageData = aResult.data[i];
      theParentDiv.append("<img src='" + theImageData.images.low_resolution.url 
                            + "' width='" + theImageData.images.low_resolution.width
                            + "' height='" + theImageData.images.low_resolution.height + "' />");
    };
    
    if (this.myMediaLoadedCompleteCallback)
    {
      this.myMediaLoadedCompleteCallback();
    }
  };
}
