var MediaSlider = function( aContainerDivSelector, aVideoModalDivSelector, anInstagramModalDivSelector )
{
  this.SLIDE_INTERVAL = 5000;
  
  this.myContainerDiv = aContainerDivSelector;
  this.myVideoModalDiv = aVideoModalDivSelector;
  this.myInstagramModalDiv = anInstagramModalDivSelector;
  this.myPlayer = null;
  this.myInstagramSearch = null;
  this.myYouTubeSearch = null;
  this.myInstagrams = {};
  this.myYouTubeVideos = {};
  this.myApiResponses = 0;
  
  this.createSliderForTeam = function( aTeamId, 
                                        aShortName,
                                        aSport, 
                                        anArrayOfHashTags )
  {
    this.myInstagramSearch = new InstagramSearch();
    this.myYouTubeSearch = new YouTubeSearch( aShortName,
                                              aSport, 
                                              anArrayOfHashTags,
                                              15);
    this.myInstagramSearch.loadMediaForTeam(aTeamId, createDelegate(this, this.onInstagramMediaLoaded));
    this.myYouTubeSearch.loadVideos(createDelegate(this, this.onYouTubeMediaLoaded));
  };
  
  this.createSliderForFanzone = function( aFanzoneId,
                                        aShortName,
                                        aSport, 
                                        anArrayOfHashTags )
  {
    this.myInstagramSearch = new InstagramSearch();
    this.myYouTubeSearch = new YouTubeSearch( aShortName,
                                              aSport, 
                                              anArrayOfHashTags,
                                              15);
    this.myInstagramSearch.loadMediaForFanzone(aFanzoneId, createDelegate(this, this.onInstagramMediaLoaded));
    this.myYouTubeSearch.loadVideos(createDelegate(this, this.onYouTubeMediaLoaded));
  };
  
  this.destroy = function()
  {
    this.stopSliderTimer();
    $(this.myContainerDiv + " div#myMediaContent").clearQueue();
    $(this.myContainerDiv + " div#myMediaContent").stop();
  };
  
  this.startSliderTimer = function()
  {
    this.stopSliderTimer();
    this.mySlideInterval = setInterval(createDelegate(this, this.onSlideInterval), this.SLIDE_INTERVAL);
  };

  this.stopSliderTimer = function()
  {
    if (this.mySlideInterval)
    {
      clearInterval(this.mySlideInterval);
    }
    this.mySlideInterval = null;
  };
  
  this.onAllMediaLoaded = function()
  {
    var theParentDiv = $(this.myContainerDiv + " div#myMediaContent");
    var theInstagramIds = _.keys(this.myInstagrams);
    var theYouTubeIds = _.keys(this.myYouTubeVideos);
    for (var i=0, y=0; i < theInstagramIds.length;) 
    {
      theParentDiv.append(this.generateMediaDivFromInstagram(this.myInstagrams[theInstagramIds[i++]]));
      if (i < theInstagramIds.length)
      {
        theParentDiv.append(this.generateMediaDivFromInstagram(this.myInstagrams[theInstagramIds[i++]]));
      }
      if (y < theYouTubeIds.length)
      {
        theParentDiv.append(this.generateMediaDivFromYouTube(this.myYouTubeVideos[theYouTubeIds[y++]]));     
      }
    };
    
    while(y < theYouTubeIds.length)
    {
      theParentDiv.append(this.generateMediaDivFromYouTube(this.myYouTubeVideos[theYouTubeIds[y++]]));     
    }
    
    $(this.myVideoModalDiv + " a[data-dismiss]").click(createDelegate(this, this.onVideoDismiss));
    $(this.myInstagramModalDiv + " #post_it").click(createDelegate(this, this.onPostInstagram));
    
    $(this.myContainerDiv).hover(createDelegate(this, this.onHoverStart), createDelegate(this, this.onHoverEnd));

    this.setupNavigation();
    this.startSliderTimer();    
  };
  
  this.setupNavigation = function()
  {
    $(this.myContainerDiv + " div#navigate_forward").click( createDelegate(this, this.slideLeft ) );
    $(this.myContainerDiv + " div#navigate_backward").click( createDelegate(this, this.slideRight ) );
  }
  
  this.onSlideInterval = function()
  {
    this.slideLeft();
  };

  this.slideLeft = function()
  {
    this.stopSliderTimer();
    var theLeftMostDivImageWidth = $(this.myContainerDiv + " div#myMediaContent div:first img").attr("width");
    $(this.myContainerDiv + " div#myMediaContent").animate({ left:"-" + theLeftMostDivImageWidth + "px"}, 
                                                                500, 
                                                                'linear', 
                                                                createDelegate(this, this.onSlideLeftComplete) );
  };
  
  this.slideRight = function()
  {
    this.stopSliderTimer();
    var theRightMostDiv = $(this.myContainerDiv + " div#myMediaContent div.mediaThumbnail:last").detach();
    if (theRightMostDiv)
    {
      var theImageWidth = $(theRightMostDiv).find("img").attr("width");
      $(this.myContainerDiv + " div#myMediaContent").prepend(theRightMostDiv);
      $(this.myContainerDiv + " div#myMediaContent").css({left:"-" + theImageWidth + "px"});
      $(this.myContainerDiv + " div#myMediaContent").animate({ left:"0px"}, 
                                                                  500, 
                                                                  'linear', 
                                                                  createDelegate(this, this.onSlideRightComplete) );
    }
  };
  
  this.onSlideRightComplete = function()
  {
    this.startSliderTimer();    
  }
  
  this.onSlideLeftComplete = function()
  {
    var theLeftMostDiv = $(this.myContainerDiv + " div#myMediaContent div:first").detach();
    if (theLeftMostDiv)
    {
      $(this.myContainerDiv + " div#myMediaContent").append(theLeftMostDiv);
      $(this.myContainerDiv + " div#myMediaContent").css({left:"0px"});
      this.startSliderTimer();    
    }
  };
  
  this.onHoverStart = function(e)
  {
    this.stopSliderTimer();
    $(this.myContainerDiv + " div#navigate_forward").fadeIn(500);
    $(this.myContainerDiv + " div#navigate_backward").fadeIn(500);
  };
  
  this.onHoverEnd = function(e)
  {
    this.startSliderTimer();
    $(this.myContainerDiv + " div#navigate_forward").fadeOut(500);
    $(this.myContainerDiv + " div#navigate_backward").fadeOut(500);
  };
  
  this.onInstagramMediaLoaded = function(anArrayOfMedia)
  {
    for (var i=0; i < anArrayOfMedia.length; i++) 
    {
      this.myInstagrams[anArrayOfMedia[i].id] = anArrayOfMedia[i];
    };

    this.myApiResponses++;
    if (this.myApiResponses >= 2)
    {
      this.onAllMediaLoaded();
    }
  };
  
  this.generateMediaDivFromInstagram = function( anInstagram ) 
  {
    var theDiv = $(this.myContainerDiv + " div#myMediaTemplate").clone().render( anInstagram, this.getInstagramDirective());
    theDiv.click(createDelegate(this, this.onInstagramClick));
    return theDiv; 
  };

  this.getInstagramDirective = function()
  {
    return {
      ".@id" : "id",
      "div.media img@src" : "images.thumbnail.url",
      "div.media img@width" : "images.thumbnail.width",
      "div.media img@height" : "images.thumbnail.height"
    }    
  };
  
  this.onInstagramClick = function(e)
  {
    var theInstagramId = $(e.currentTarget).attr("id");
    var theInstagram = this.myInstagrams[theInstagramId];
    $(this.myInstagramModalDiv + " div.instagramImage").html("<img src='" + theInstagram.images.low_resolution.url + "' width='306' height='306'/>");
    $(this.myInstagramModalDiv + " div.instagramCaption").text(theInstagram.caption.text);
    $(this.myInstagramModalDiv + " div.modal-header h3").text(theInstagram.user.full_name);
    $(this.myInstagramModalDiv + " div.modal-header img").attr("src", theInstagram.caption.from.profile_picture);
    $(this.myInstagramModalDiv + " #post_it").attr("data-id", theInstagramId);

    $(".modal").modal("hide");
    $(this.myInstagramModalDiv).modal("show");
  };

  this.onYouTubeMediaLoaded = function(anArrayOfMedia)
  {
    for (var i=0; i < anArrayOfMedia.length; i++) 
    {
      this.myYouTubeVideos[anArrayOfMedia[i].media$group.yt$videoid.$t] = anArrayOfMedia[i];
    };

    this.myApiResponses++;
    if (this.myApiResponses >= 2)
    {
      this.onAllMediaLoaded();
    }
  };
  
  this.generateMediaDivFromYouTube = function( aYouTubeVideo ) 
  {
    var theDiv = $(this.myContainerDiv + " div#myMediaTemplate").clone().render( aYouTubeVideo, this.getYouTubeDirective());
    theDiv.click(createDelegate(this, this.onYouTubeClick));
    return theDiv; 
  };
  
  this.getYouTubeDirective = function()
  {
    return {
      ".@id" : "media$group.yt$videoid.$t",
      "div.media img@src" : function(anItem){ return anItem.context.media$group.media$thumbnail[0].url; },
      "div.media img@width" : function(anItem)
        { 
          var theWidth =  anItem.context.media$group.media$thumbnail[0].width * 150 
                          / anItem.context.media$group.media$thumbnail[0].height;
          return theWidth.toString()
        },
      "div.media img@height" : function(anItem){return "150";},
      "div.mediaAnnotation" : function(anItem){ return "<div class='playButton'></div>";},
      "div.mediaAnnotation@class" : function(anItem){ return "mediaAnnotation playButtonBackground";}
    }    
  };
  
  this.onYouTubeClick = function(e)
  {
    var theVideoId = $(e.currentTarget).attr("id");
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
    
    var theVideo = this.myYouTubeVideos[theVideoId];
    $(this.myVideoModalDiv + " div.modal-header h3").text(theVideo.title.$t);
    

    $(".modal").modal("hide");
    $(this.myVideoModalDiv).modal("show");
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
  };
  
  this.onPostInstagram = function(e)
  {
    var theInstagramId = $(e.target).attr("data-id");
    var theInstagram = this.myInstagrams[theInstagramId];
    var theUrl = theInstagram.images.low_resolution.url;
    
    $("#postForm #post_image_url").val(theUrl);
    $("#postForm .media_container").html("<img src='" + theUrl + "' width='306' height='306'/>");
    $("#postForm .media_preview").slideDown(600);
  }

};


var myCurrentMediaSlider = null;
MediaSlider.create = function(aContainerDivSelector, aVideoModalDivSelector, anInstagramModalDivSelector)
{
  if (myCurrentMediaSlider)
  {
    myCurrentMediaSlider.destroy();
  }
  myCurrentMediaSlider = new MediaSlider(aContainerDivSelector, aVideoModalDivSelector, anInstagramModalDivSelector);
  
  return myCurrentMediaSlider;
};
