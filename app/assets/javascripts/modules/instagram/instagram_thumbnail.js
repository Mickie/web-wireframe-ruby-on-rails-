var InstagramThumbnail = function( anInstagramView )
{
  BaseThumbnail.apply(this, arguments);
  
  this.getRenderDirective = function()
  {
    return {
      ".@id" : "id",
      "div.media img@style" : function(anItem){return "";},
      "div.media img@alt" : "caption.text",
      "div.media img@src" : "images.thumbnail.url",
      "div.media img@width" : "images.thumbnail.width",
      "div.media img@height" : "images.thumbnail.height"
    }    
  };
  
}
InstagramThumbnail.subclass(BaseThumbnail);
