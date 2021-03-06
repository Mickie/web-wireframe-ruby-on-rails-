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
    
    this.myDialogDiv.find("#post_media_button").click(createDelegate(this, this.onPostYouTube));
    this.myDialogDiv.on('hidden', createDelegate(this, this.onDialogHidden));

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
  
  this.showVideoDialog = function( aVideoId, aTitle, aDescription )
  {
    this.myDialogDiv.find("div.modal-body h3").text( aTitle );
    this.myDialogDiv.find("div.modal-body img.profile_pic").hide();
    this.myDialogDiv.find("div.mediaCaption").text(aDescription);
    
    this.loadYouTubeInDialog(aVideoId);
    
    this.myDialogDiv.find("#mediaImageData").hide();
    this.myDialogDiv.find("#mediaVideoData").show();

    $(".modal").modal("hide");
    this.myDialogDiv.modal("show");
  };
  
  this.onDialogHidden = function(e)
  {
    this.myDialogDiv.find("#post_media_button").data("youtubeVideo", null).hide();
    this.cleanupDialogPlayer();
  };
  
  this.onPostedVideoClick = function(e)
  {
    // TODO get data via odata
    var theVideoId = $(e.currentTarget).attr("id");
    this.myDialogDiv.find("#post_media_button").hide();
    this.showVideoDialog( theVideoId, "", "" );

    trackEvent("PostAndComments", "youtube_click", theVideoId);    
  };  
  
  this.showDialog = function( aYoutubeVideo )
  {
    var theVideoId = aYoutubeVideo.media$group.yt$videoid.$t;
    this.myDialogDiv.find("#post_media_button").data("youtubeVideo", aYoutubeVideo).show();
    this.showVideoDialog( theVideoId, aYoutubeVideo.title.$t, aYoutubeVideo.media$group.media$description.$t );
    
    trackEvent("MediaSlider", "youtube_click", theVideoId);    
  };
  
  this.onPostYouTube = function(e)
  {
    var theVideo = $(e.target).data("youtubeVideo");
    if (theVideo)
    {
      var theVideoId = theVideo.media$group.yt$videoid.$t;
      
      var theThumbnailUrl = theVideo.media$group.media$thumbnail[0].url
      for (var i = 0; i < theVideo.media$group.media$thumbnail.length; i++)
      {
        if ( theVideo.media$group.media$thumbnail[i].yt$name == "hqdefault" )
        {
          theThumbnailUrl = theVideo.media$group.media$thumbnail[i].url;
          break;
        }
      }

      this.addYoutubeVideoToPost(theVideoId, theThumbnailUrl);      
      
      trackEvent("MediaSlider", "post_youtube", theVideoId);
      $(".modal").modal("hide");
    }
  };
  
  this.addYoutubeVideoToPost = function( aVideoId, aThumbnailUrl )
  {
    this.myPostDiv.find("#post_video_id").val(aVideoId);
    this.myPostDiv.find("#post_image_url").val(aThumbnailUrl);
    this.loadYouTubeInPost(aVideoId);
    this.myPostDiv.find(".video_container").slideDown(600);
    this.myPostDiv.find(".image_container").hide();
    this.myPostDiv.find("#photo_picker").hide();
  };
  
  this.loadYouTubeInPost = function( aVideoId )
  {
    if (!this.myPostPlayer)
    {
      var theWidth = '320';
      var theHeight = '195';
      
      if (UserManager.get().isMobile())
      {
        theWidth = '260';
        theHeight = '160';
      }
      this.myPostPlayer = new YT.Player('post_youtube', 
                                        {
                                          height: theHeight,
                                          width: theWidth,
                                          videoId: aVideoId
                                        });
    }
    else
    {
      try
      {
        this.myPostPlayer.loadVideoById(aVideoId);
      }
      catch(error)
      {
        console.log(error);
      }
    }
  };
  
  this.loadYouTubeInDialog = function( aVideoId )
  {
    if (!this.myDialogPlayer)
    {
      var theWidth = '640';
      var theHeight = '390';
      
      if (UserManager.get().isMobile())
      {
        theWidth = '280';
        theHeight = '170';
      }
      this.myDialogPlayer = new YT.Player('player', 
                                          {
                                            height: theHeight,
                                            width: theWidth,
                                            videoId: aVideoId
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
      if( aPlayer.getPlayerState && aPlayer.getPlayerState() > 0 )
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
  
}
