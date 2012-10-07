var AmazonProductThumbnail = function( aAmazonView )
{
  BaseThumbnail.apply(this, arguments);
  
  this.getRenderDirective = function()
  {
    function getWidth(aProduct)
    {
      var theWidth = (aProduct.context.imageWidth * 150)/aProduct.context.imageHeight;
      return Math.round(theWidth).toString();
    }

    return {
      ".@id" : "ID",
      ".@style" : function(aProduct)
      {
        theWidth = getWidth(aProduct);
        return "width:" + theWidth + "px;"
      },
      "div.mediaAnnotation" : function(aProduct)
      { 
        return "";//"<div class='AmazonProductItem'>" + aProduct.context.title + "</div>";
      },
      "div.media img@style" : function(){return "";},
      "div.media img@alt" : function(aProduct){return aProduct.context.title;},
      "div.media img@title" : function(aProduct){return aProduct.context.title;},
      "div.media img@src" : function(aProduct){return aProduct.context.imageUrl;},
      "div.media img@width" : getWidth,
      "div.media img@height" : function(){return "150";}
     }    
  };
}
AmazonProductThumbnail.subclass(BaseThumbnail);
