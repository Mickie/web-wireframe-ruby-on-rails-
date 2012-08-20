var YoutubeView = function(aContainerDivSelector, 
                           aModalDivSelector, 
                           aPostDivSelector)
{
  this.myContainerDiv = $(aContainerDivSelector);
  this.myDialogDiv = $(aModalDivSelector);
  this.myPostDiv = $(aPostDivSelector);
  
  this.myPostPlayer = null;
  this.myDialogPlayer = null;
  
  this.myYoutubeSearch = null;
  this.myYouTubeVideos = {};
  this.myElements = new Array();
  this.myThumbnails = new Array();
  this.myAbortFlag = false;
  
  this.beginLoading = function(aShortName, aSport, anArrayOfHashTags)
  {
    this.myYouTubeSearch = new YouTubeSearch( aShortName,
                                              aSport, 
                                              anArrayOfHashTags,
                                              this.myElements.length);
    this.myYouTubeSearch.loadVideos(createDelegate(this, this.onYouTubeMediaLoaded));
  };
  
  this.queueContainerLoad = function( anElement )
  {
    this.myElements.push( anElement );
  };
  
  this.cleanup = function()
  {
    this.myAbortFlag = true;
    
    this.cleanupDialogPlayer();
    this.myDialogPlayer = null;

    this.cleanupPostPlayer();
    this.myPostPlayer = null;

    if (this.myYouTubeSearch)
    {
      this.myYouTubeSearch.abort();
      this.myYouTubeSearch = null;
    }
    
    this.cleanupThumbnails();

    this.myYouTubeVideos = {};
  };
  
  this.onYouTubeMediaLoaded = function(anArrayOfMedia)
  {
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.myYouTubeVideos = anArrayOfMedia;
    $(this.myElements).each(createDelegate(this, this.createThumbnail));
    
    this.myDialogDiv.find("a[data-dismiss]").click(createDelegate(this, this.onVideoDismiss));
    this.myDialogDiv.find("#post_video_button").click(createDelegate(this, this.onPostYouTube));

    $("#posts").on( "click", ".post_video", createDelegate(this, this.onPostedVideoClick) );
  };
  
  this.createThumbnail = function(anIndex, anElement )
  {
    if (anIndex < this.myYouTubeVideos.length)
    {
      this.myThumbnails[anIndex] = new YoutubeThumbnail(this);
      this.myThumbnails[anIndex].initialize( this.myYouTubeVideos[anIndex], anElement );
    }
  };
  
  this.cleanupThumbnails = function()
  {
    for(var i=0,j=this.myThumbnails.length; i<j; i++)
    {
      this.myThumbnails[i].cleanup();
    };
    this.myThumbnails = new Array();
  };
  
  this.onPostedVideoClick = function(e)
  {
    var theVideoId = $(e.currentTarget).attr("id");
    this.loadYouTubeInDialog(theVideoId);
    $(".modal").modal("hide");
    this.myDialogDiv.find("#post_video_button").hide();
    this.myDialogDiv.modal("show");
  };  
  
  this.showDialog = function( aYoutubeVideo )
  {
    var theVideoId = aYoutubeVideo.media$group.yt$videoid.$t;
    
    this.myDialogDiv.find("div.modal-header h3").text(aYoutubeVideo.title.$t);
    this.myDialogDiv.find("#post_video_button").data("youtubeVideo", aYoutubeVideo).show();
    
    this.loadYouTubeInDialog(theVideoId);
    $(".modal").modal("hide");
    this.myDialogDiv.modal("show");
    
    trackEvent("MediaSlider", "youtube_click", theVideoId);    
  };
  
  this.onPostYouTube = function(e)
  {
    var theVideo = $(e.target).data("youtubeVideo");
    var theVideoId = theVideo.media$group.yt$videoid.$t;
    
    var theThumbnailUrl = theVideo.media$group.media$thumbnail[0].url
    for (var i = 0; i < theVideo.media$group.media$thumbnail.length; i++)
    {
      if ( theVideo.media$group.media$thumbnail[i].yt$name == "hqdefault" )
      {
        theThumbnailUrl = theVideo.media$group.media$thumbnail[i].url;
      }
    }
    
    this.myPostDiv.find("#post_video_id").val(theVideoId);
    this.myPostDiv.find("#post_image_url").val(theThumbnailUrl);
    this.myPostDiv.find(".media_container").html("<div id='post_youtube'></div>");
    this.loadYouTubeInPost(theVideoId);
    this.myPostDiv.find(".media_preview").slideDown(600);
    
    trackEvent("MediaSlider", "post_youtube", theVideoId);    
  };
  
  
  this.loadYouTubeInPost = function( aVideoId )
  {
    if (!this.myPostPlayer)
    {
      this.myPostPlayer = new YT.Player('post_youtube', 
                                        {
                                          height: '195',
                                          width: '320',
                                          videoId: aVideoId,
                                          events: 
                                          {
                                            'onReady': createDelegate(this, this.onPlayerReady),
                                            'onStateChange': createDelegate(this, this.onPlayerStateChange)
                                          }
                                        });
    }
    else
    {
      this.myPostPlayer.loadVideoById(aVideoId);
    }
  };
  
  this.loadYouTubeInDialog = function( aVideoId )
  {
    if (!this.myDialogPlayer)
    {
      this.myDialogPlayer = new YT.Player('player', 
                                          {
                                            height: '390',
                                            width: '640',
                                            videoId: aVideoId,
                                            events: 
                                            {
                                              'onReady': createDelegate(this, this.onPlayerReady),
                                              'onStateChange': createDelegate(this, this.onPlayerStateChange)
                                            }
                                          });
    }
    else
    {
      this.myDialogPlayer.loadVideoById(aVideoId);
    }
  };
  
  this.cleanupPlayer = function(aPlayer)
  {
    if (aPlayer)
    {
      if( aPlayer.getPlayerState() > 0 )
      {
        aPlayer.stopVideo();
      }
      if (aPlayer.clearVideo)
      {
        aPlayer.clearVideo();
      }
    } 
  };
  
  this.cleanupDialogPlayer = function()
  {
    this.cleanupPlayer(this.myDialogPlayer)
  };

  this.cleanupPostPlayer = function()
  {
    this.cleanupPlayer(this.myPostPlayer)
  };
  

  this.onVideoDismiss = function(e)
  {
    this.cleanupDialogPlayer();
  };

  this.onPlayerReady = function()
  {
    
  };
  
  this.onPlayerStateChange = function()
  {
    
  };

}
