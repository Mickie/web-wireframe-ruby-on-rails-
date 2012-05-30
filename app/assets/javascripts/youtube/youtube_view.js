var YOUTUBE_VIDEO_SEARCH_URL = "http://gdata.youtube.com/feeds/api/videos";

function onYouTubePlayerAPIReady() 
{
  myYouTubeView.loadVideos();
}

var YouTubeView = function( aShortName,
                            aSport, 
                            anArrayOfHashTags,
                            aMaxVideos, 
                            aVideoDivId)
{
  this.myShortName = aShortName;
  this.mySport = aSport;
  this.myHashTags = anArrayOfHashTags;
  this.myMaxVideos = aMaxVideos;
  this.myVideoDivSelector = "#" + aVideoDivId;
  this.myPlayer = null;
  
  this.loadSDK = function()
  {
    var theTag = document.createElement('script');
    theTag.src = "http://www.youtube.com/player_api";
    var theFirstScriptTag = document.getElementsByTagName('script')[0];
    theFirstScriptTag.parentNode.insertBefore(theTag, theFirstScriptTag);  
  }
  
  this.loadVideos = function()
  {
    var theQueryString = "?alt=json-in-script&format=5,6&hd&category=Sports&v=2&q=" 
                          + escape(this.getQuery()) 
                          + "&max-results=" + this.myMaxVideos;
    $.ajax({
             url: YOUTUBE_VIDEO_SEARCH_URL + theQueryString,
             cache:false,
             dataType: "jsonp",
             success: createDelegate(this, this.onSearchComplete)
           });
  };
  
  this.onSearchComplete = function( aResult )
  {
    var theEntries = aResult.feed.entry || [];

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
  
  this.getQuery = function()
  {
    var theName = '"' + this.myShortName + ' ' + this.mySport + '"';
    return theName + '|' + this.myHashTags.join('|').replace(/#/g, "");
  };
  
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
