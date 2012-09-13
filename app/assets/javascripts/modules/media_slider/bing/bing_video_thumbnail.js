var BingVideoThumbnail = function( aBingView )
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
      "div.media img@src" : "Thumbnail.MediaUrl",
      "div.media img@width" : getWidth,
      "div.media img@height" : function(){return "150";},
      "div.mediaAnnotation" : function(){ return "<div class='playButton'></div>";},
      "div.mediaAnnotation@style" : function(anItem)
      {
        var theWidth = (anItem.context.Thumbnail.Width * 150)/anItem.context.Thumbnail.Height;
        var theLeft = (theWidth - 100)/2;         
        return "left: " + theLeft + "px;";
      },
      "div.mediaAnnotation@class" : function(){ return "mediaAnnotation playButtonBackground";}
    }    
  };
  
}
BingImageThumbnail.subclass(BaseThumbnail);
