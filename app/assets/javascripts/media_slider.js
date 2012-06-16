var MediaSlider = function( aContainerDivId )
{
  this.myInstagramSearch = new InstagramSearch();
  this.myContainerDiv = "div#" + aContainerDivId;
  
  this.createSliderForTeam = function( aTeamId )
  {
    this.myInstagramSearch.loadMediaForTeam(aTeamId, createDelegate(this, this.onInstagramMediaLoaded));
  };
  
  this.onInstagramMediaLoaded = function(anArrayOfMedia)
  {
    var theParentDiv = $(this.myContainerDiv);
    for (var i=0; i < anArrayOfMedia.length; i++) 
    {
      theParentDiv.append(this.generateMediaDivFromInstagram(anArrayOfMedia[i]))      
    };
  };
  
  this.generateMediaDivFromInstagram = function( anInstagram ) 
  {
    var theDiv = $(this.myContainerDiv + " div#myMediaTemplate").clone().render( anInstagram, this.getInstagramDirective());
    theDiv.find("img").click(createDelegate(this, this.onInstagramClick));
    return theDiv; 
  };
  
  this.getInstagramDirective = function()
  {
    var theThis = this;
    return {
      ".@id" : "id",
      "img@src" : "images.thumbnail.url",
      "img@width" : "images.thumbnail.width",
      "img@height" : "images.thumbnail.height"
    }    
  };
  
  this.onInstagramClick = function(e)
  {
    console.log("click");
  };
}
