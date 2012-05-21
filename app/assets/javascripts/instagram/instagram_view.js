var InstagramView = function(aDivId)
{
  this.myContentDivSelector = "div#" + aDivId;
  this.myTeamId = "";
  
  this.startLoadingImagesForTeam = function( aTeamId )
  {
    this.myTeamId = aTeamId;
    $.getJSON("/instagram_proxy/find_tags.json?team_id=" + this.myTeamId, 
              createDelegate(this, this.onFindTagsComplete));
  };
  
  this.onFindTagsComplete = function(aResult)
  {
    for (var i=0; i < aResult.length; i++) 
    {
      var theTag = aResult[i];
      this.createSlideHolderForTag(theTag.name);
      this.loadMediaForTag(theTag.name);
    };
  };
  
  this.createSlideHolderForTag = function(aTag)
  {
    $(this.myContentDivSelector).append('<div id="slides_' + aTag + '"><div class="slides_container"></div></div>');
  };
  
  this.loadMediaForTag = function( aTag )
  {
    $.getJSON("/instagram_proxy/media_for_tag?tag=" + escape(aTag),
              createExtendedDelegate(this, this.onMediaForTagComplete, [aTag]));
  };
  
  this.onMediaForTagComplete = function(aResult, aTextStatus, aJQXHR, aTag)
  {
    var theParentDiv = $("div#slides_" + aTag + " div.slides_container");
    for (var i=0; i < aResult.data.length; i++) 
    {
      theImageData = aResult.data[i];
      theParentDiv.append("<img src='" + theImageData.images.low_resolution.url 
                            + "' width='" + theImageData.images.low_resolution.width
                            + "' height='" + theImageData.images.low_resolution.height + "' />");
    };

    this.startSlideshowForTag(aTag);    
  };
  
  this.startSlideshowForTag = function( aTag )
  {
    var theSlideContainerSelector = "div#slides_" + aTag;
    $(theSlideContainerSelector).slides({
      preload: true,
      play: 5000,
      pause: 2500,
      hoverPause: true,
      generatePagination: false
    });
  }
}
