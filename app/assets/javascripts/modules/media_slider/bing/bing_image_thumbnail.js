var BingImageThumbnail = function( aBingView )
{
  BaseThumbnail.apply(this, arguments);
  
  this.getRenderDirective = function()
  {
    return {
      ".@id" : "ID",
      "div.media img@style" : function(){return "";},
      "div.media img@alt" : "Title",
      "div.media img@src" : "Thumbnail.MediaUrl",
      "div.media img@width" : function(anItem)
      {
        var theWidth = (anItem.context.Thumbnail.Width * 150)/anItem.context.Thumbnail.Height;
        return theWidth.toString();
      },
      "div.media img@height" : function(){return "150";}
    }    
  };
  
}
BingImageThumbnail.subclass(BaseThumbnail);
