
var YouTubeView = function( aShortName,
                            aSport, 
                            anArrayOfHashTags,
                            aMaxVideos, 
                            aVideoDivId)
{
  this.myVideoDivSelector = "#" + aVideoDivId;
  this.myPlayer = null;
  this.myYouTubeSearch = new YouTubeSearch(aShortName, aSport, anArrayOfHashTags, aMaxVideos);
  
  this.loadVideos = function()
  {
    this.myYouTubeSearch.loadVideos(createDelegate(this, this.onSearchComplete));
  };
  
  this.onSearchComplete = function( aResult )
  {
    var theEntries = aResult;

    if (theEntries.length > 0)
    {
      $(this.myVideoDivSelector).append('<div id="youtube_thumbnail_slideshow"><div class="slides_container"></div></div>');
      for (var i=0; i < theEntries.length; i++) 
      {
        var theVideo = theEntries[i];
        var theThumbnail = theVideo.media$group.media$thumbnail[2];
        var theVideoId = theVideo.media$group.yt$videoid.$t;
        $(this.myVideoDivSelector + " div.slides_container").append("<img src='" + theThumbnail.url 
                              + "' width='" + theThumbnail.width
                              + "' height='" + theThumbnail.height + "' data='" + theVideoId + "' />");
        
      }
      
      $(this.myVideoDivSelector + " div.slides_container img").click(createDelegate(this, this.onThumbnailClick));
      $("#myVideoModal a[data-dismiss]").click(createDelegate(this, this.onVideoDismiss))
    
      this.startSlideshow();
    }
    
  };
  
  this.onThumbnailClick = function(e)
  {
    var theVideoId = e.target.attributes.getNamedItem('data').nodeValue;
    if (!this.myPlayer)
    {
      this.myPlayer = new YT.Player('player', {
                                    height: '390',
                                    width: '640',
                                    videoId: theVideoId,
                                    events: {
                                      'onReady': createDelegate(this, this.onPlayerReady),
                                      'onStateChange': createDelegate(this, this.onPlayerStateChange)
                                    }
                                  });
    }
    else
    {
      this.myPlayer.loadVideoById(theVideoId);
    }
        
            
    $(".modal").modal("hide");
    $("#myVideoModal").modal("show");
  };
  
  this.onPlayerReady = function()
  {
    
  };
  
  this.onPlayerStateChange = function()
  {
    
  };
  
  this.onVideoDismiss = function(e)
  {
    this.myPlayer.stopVideo();
    this.myPlayer.clearVideo();
  }
  
  this.startSlideshow = function()
  {
    $("div#youtube_thumbnail_slideshow").slides({
      preload: true,
      preloadImage: '/assets/loading.gif',
      play: 10000,
      pause: 2500,
      hoverPause: true,
      generatePagination: false
    });
  }
  
}
