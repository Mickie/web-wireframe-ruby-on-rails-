var YoutubeThumbnail = function( aYoutubeView )
{
  this.myYoutubeView = aYoutubeView;
  this.myElement;
  this.myData;
  
  this.initialize = function( aData, anElement )
  {
    this.myData = aData;
    this.myElement = anElement;
    
    try
    {
      this.myElement = anElement.render( this.myData, this.getYoutubeDirective() );
      this.myElement.click( createDelegate(this, this.onClick ) );
    }
    catch(anError)
    {
      console.log(anError);      
    }
  };
  
  this.getYoutubeDirective = function()
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
  
  this.onClick = function(e)
  {
    this.myYoutubeView.showDialog(this.myData);
  };
  
  
  
  
  
}