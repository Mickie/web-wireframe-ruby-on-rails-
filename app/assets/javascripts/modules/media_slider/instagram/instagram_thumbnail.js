var InstagramThumbnail = function( anInstagramView )
{
  BaseThumbnail.apply(this, arguments);
  
  this.getRenderDirective = function()
  {
    return {
      ".@id" : "id",
      ".@style" : function(anItem)
      {
        return "width:" + anItem.context.images.thumbnail.width + "px;"
      },
      "div.media img@src" : function(anItem)
      {
        return makeUrlHttpsSafe(anItem.context.images.thumbnail.url);
      },
      "div.media img@style" : function(anItem){return "";},
      "div.media img@alt" : "caption.text",
      "div.media img@width" : "images.thumbnail.width",
      "div.media img@height" : "images.thumbnail.height"
    }    
  };
  
}
InstagramThumbnail.subclass(BaseThumbnail);
