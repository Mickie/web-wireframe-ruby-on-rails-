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
        var theUrl = anItem.context.images.thumbnail.url;
        if ('https:' == document.location.protocol)
        {
          theUrl = theUrl.replace("http", "https");
        } 
        return theUrl;
      },
      "div.media img@style" : function(anItem){return "";},
      "div.media img@alt" : "caption.text",
      "div.media img@width" : "images.thumbnail.width",
      "div.media img@height" : "images.thumbnail.height"
    }    
  };
  
}
InstagramThumbnail.subclass(BaseThumbnail);
