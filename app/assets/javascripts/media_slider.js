var MediaSlider = function( aContainerDivId, aVideoModalDivId )
{
  this.myContainerDiv = "div#" + aContainerDivId;
  this.myVideoModalDiv = "div#" + aVideoModalDivId;
  this.myPlayer = null;
  this.myInstagramSearch = null;
  this.myYouTubeSearch = null;
  this.myInstagrams = {};
  this.myYouTubeVideos = {};
  
  this.createSliderForTeam = function( aTeamId, 
                                        aShortName,
                                        aSport, 
                                        anArrayOfHashTags,
                                        aMaxVideos )
  {
    this.myInstagramSearch = new InstagramSearch();
    this.myYouTubeSearch = new YouTubeSearch( aShortName,
                                              aSport, 
                                              anArrayOfHashTags,
                                              aMaxVideos);
    this.myInstagramSearch.loadMediaForTeam(aTeamId, createDelegate(this, this.onInstagramMediaLoaded));
    this.myYouTubeSearch.loadVideos(createDelegate(this, this.onYouTubeMediaLoaded));
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
    
    this.mySlideInterval = setInterval(createDelegate(this, this.onSlideInterval), 1000);
  };
  
  this.onSlideInterval = function()
  {
    var theLeftMostDivImageWidth = $(this.myContainerDiv + " div#myMediaContent div:first img").attr("width");
    clearInterval(this.mySlideInterval);
    $(this.myContainerDiv + " div#myMediaContent").animate({ left:"-" + theLeftMostDivImageWidth + "px"}, 
                                                                500, 
                                                                'linear', 
                                                                createDelegate(this, this.onTransitionComplete) );
  };
  
  this.onTransitionComplete = function()
  {
    var theLeftMostDiv = $(this.myContainerDiv + " div#myMediaContent div:first").detach();
    $(this.myContainerDiv + " div#myMediaContent").append(theLeftMostDiv);
    $(this.myContainerDiv + " div#myMediaContent").css({left:"0px"});
    this.mySlideInterval = setInterval(createDelegate(this, this.onSlideInterval), 1000);
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
    console.log("here");
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
  }
  

}
