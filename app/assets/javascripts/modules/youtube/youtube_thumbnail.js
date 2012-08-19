var YoutubeThumbnail = function( aYoutubeView )
{
  BaseThumbnail.apply(this, arguments);

  this.getRenderDirective = function()
  {
    return {
      ".@id" : "media$group.yt$videoid.$t",
      "div.media img@alt" : "title.$t",
      "div.media img@src" : function(anItem){ return anItem.context.media$group.media$thumbnail[0].url; },
      "div.media img@width" : function(anItem)
        { 
          var theWidth =  anItem.context.media$group.media$thumbnail[0].width * 150 
                          / anItem.context.media$group.media$thumbnail[0].height;
          return theWidth.toString()
        },
      "div.media img@style" : function(anItem){return "";},
      "div.media img@height" : function(anItem){return "150";},
      "div.mediaAnnotation" : function(anItem){ return "<div class='playButton'></div>";},
      "div.mediaAnnotation@class" : function(anItem){ return "mediaAnnotation playButtonBackground";}
    }    
  };
  
}
YoutubeThumbnail.subclass(BaseThumbnail);

