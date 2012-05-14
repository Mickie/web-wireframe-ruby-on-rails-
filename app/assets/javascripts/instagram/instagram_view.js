var InstagramView = function(aDivId, aTeamId)
{
  this.myContentDivSelector = "#" + aDivId;
  this.myTeamId = aTeamId;
  
  this.startLoadingImages = function()
  {
    $.getJSON("/instagram_proxy/find_tags.json?team_id=" + this.myTeamId, 
              createDelegate(this, this.onFindTagsComplete));
  };
  
  this.onFindTagsComplete = function(aResult)
  {
    for (var i=0; i < aResult.length; i++) 
    {
      var theTag = aResult[i];
      this.loadMediaForTag(theTag.name);
    };
  };
  
  this.loadMediaForTag = function( aTag )
  {
    $.getJSON("/instagram_proxy/media_for_tag?tag=" + escape(aTag),
              createDelegate(this, this.onMediaForTagComplete));
  };
  
  this.onMediaForTagComplete = function(aResult)
  {
    for (var i=0; i < aResult.data.length; i++) 
    {
      theImageData = aResult.data[i];
      $(this.myContentDivSelector).append("<img src='" + theImageData.images.low_resolution.url 
                                          + "' width='" + theImageData.images.low_resolution.width
                                          + "' height='" + theImageData.images.low_resolution.height + "' />");
    };
  };
}
