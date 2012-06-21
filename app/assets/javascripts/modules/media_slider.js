var MediaSlider = function( aContainerDivSelector, aVideoModalDivSelector, anInstagramModalDivSelector )
{
  this.myContainerDiv = aContainerDivSelector;
  this.myVideoModalDiv = aVideoModalDivSelector;
  this.myInstagramModalDiv = anInstagramModalDivSelector;
  this.myPlayer = null;
  this.myInstagramSearch = null;
  this.myYouTubeSearch = null;
  this.myInstagrams = {};
  this.myYouTubeVideos = {};
  
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
  
  this.destroy = function()
  {
    this.stopSliderTimer();
    $(this.myContainerDiv + " div#myMediaContent").clearQueue();
    $(this.myContainerDiv + " div#myMediaContent").stop();
  };
  
  this.startSliderTimer = function()
  {
    this.mySlideInterval = setInterval(createDelegate(this, this.onSlideInterval), 10000);
  };

  this.stopSliderTimer = function()
  {
    clearInterval(this.mySlideInterval);
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
    
    $(this.myContainerDiv).hover(createDelegate(this, this.onHoverStart), createDelegate(this, this.onHoverEnd));

    this.startSliderTimer();    
  };
  
  this.onSlideInterval = function()
  {
    var theLeftMostDivImageWidth = $(this.myContainerDiv + " div#myMediaContent div:first img").attr("width");
    this.stopSliderTimer();
    $(this.myContainerDiv + " div#myMediaContent").animate({ left:"-" + theLeftMostDivImageWidth + "px"}, 
                                                                500, 
                                                                'linear', 
                                                                createDelegate(this, this.onTransitionComplete) );
  };
  
  this.onTransitionComplete = function()
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
  };
  
  this.onHoverEnd = function(e)
  {
    this.startSliderTimer();
  };
  
  this.onInstagramMediaLoaded = function(anArrayOfMedia)
  {
    for (var i=0; i < anArrayOfMedia.length; i++) 
    {
      this.myInstagrams[anArrayOfMedia[i].id] = anArrayOfMedia[i];
    };

    if (_.keys(this.myYouTubeVideos).length > 0)
    {
      this.onAllMediaLoaded();
    }
  };
  
  this.generateMediaDivFromInstagram = function( anInstagram ) 
  {
    var theDiv = $(this.myContainerDiv + " div#myMediaTemplate").clone().render( anInstagram, this.getInstagramDirective());
    theDiv.find("img").click(createDelegate(this, this.onInstagramClick));
    return theDiv; 
  };

  this.getInstagramDirective = function()
  {
    return {
      ".@id" : "id",
      "img@src" : "images.thumbnail.url",
      "img@width" : "images.thumbnail.width",
      "img@height" : "images.thumbnail.height"
    }    
  };
  
  this.onInstagramClick = function(e)
  {
    var theInstagramId = $(e.target.parentElement).attr("id");
    var theInstagram = this.myInstagrams[theInstagramId];
    $(this.myInstagramModalDiv + " div#instagramImage").html("<img src='" + theInstagram.images.standard_resolution.url + "' width='612' height=612'/>");
    $(this.myInstagramModalDiv + " div.modal-header h3").text(theInstagram.user.full_name);
    $(this.myInstagramModalDiv + " div.modal-header img").attr("src", theInstagram.caption.from.profile_picture);

    $(".modal").modal("hide");
    $(this.myInstagramModalDiv).modal("show");
  };

  this.onYouTubeMediaLoaded = function(anArrayOfMedia)
  {
    for (var i=0; i < anArrayOfMedia.length; i++) 
    {
      this.myYouTubeVideos[anArrayOfMedia[i].media$group.yt$videoid.$t] = anArrayOfMedia[i];
    };

    if (_.keys(this.myInstagrams).length > 0)
    {
      this.onAllMediaLoaded();
    }
  };
  
  this.generateMediaDivFromYouTube = function( aYouTubeVideo ) 
  {
    var theDiv = $(this.myContainerDiv + " div#myMediaTemplate").clone().render( aYouTubeVideo, this.getYouTubeDirective());
    theDiv.find("img").click(createDelegate(this, this.onYouTubeClick));
    return theDiv; 
  };
  
  this.getYouTubeDirective = function()
  {
    return {
      ".@id" : "media$group.yt$videoid.$t",
      "img@src" : function(anItem){ return anItem.context.media$group.media$thumbnail[0].url; },
      "img@width" : function(anItem)
        { 
          var theWidth =  anItem.context.media$group.media$thumbnail[0].width * 150 
                          / anItem.context.media$group.media$thumbnail[0].height;
          return theWidth.toString()
        },
      "img@height" : function(anItem){return "150";}
    }    
  };
  
  this.onYouTubeClick = function(e)
  {
    var theVideoId = $(e.target.parentElement).attr("id");
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