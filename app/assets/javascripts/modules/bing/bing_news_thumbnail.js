var BingNewsThumbnail = function( aBingView )
{
  BaseThumbnail.apply(this, arguments);
  
  this.getRenderDirective = function()
  {
    return {
      ".@id" : "ID",
      "div.media" : function(){return "";},
      "div.mediaAnnotation" : function(anItem)
      { 
        var theHtml = "<h3>" + anItem.context.Title + "</h3>";
        if (anItem.context.Source)
        {
          theHtml += "<p>" + anItem.context.Source + "</p>";
        }
        return "<div class='bingNewsItem'>" + theHtml + "</div>";
      },
      "div.mediaAnnotation@class" : function(anItem){ return "mediaAnnotation bingNewsBackground";}
    }    
  };
  
}
BingNewsThumbnail.subclass(BaseThumbnail);
