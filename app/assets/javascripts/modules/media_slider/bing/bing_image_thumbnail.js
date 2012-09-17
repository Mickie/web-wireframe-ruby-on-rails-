var BingImageThumbnail = function( aBingView )
{
  BaseThumbnail.apply(this, arguments);
  
  this.getRenderDirective = function()
  {
    function getWidth(anItem)
    {
      var theWidth = (anItem.context.Thumbnail.Width * 150)/anItem.context.Thumbnail.Height;
      return Math.round(theWidth).toString();
    }

    return {
      ".@id" : "ID",
      ".@style" : function(anItem)
      {
        theWidth = getWidth(anItem);
        return "width:" + theWidth + "px;"
      },
      "div.media img@style" : function(){return "";},
      "div.media img@alt" : "Title",
      "div.media img@title" : "Title",
      "div.media img@src" : "Thumbnail.MediaUrl",
      "div.media img@width" : getWidth,
      "div.media img@height" : function(){return "150";}
    }    
  };
  
}
BingImageThumbnail.subclass(BaseThumbnail);
