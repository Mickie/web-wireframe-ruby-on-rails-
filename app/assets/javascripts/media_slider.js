var MediaSlider = function( aContainerDivId, aVideoModalDivId )
{
  this.myContainerDiv = "div#" + aContainerDivId;
  this.myVideoModalDiv = "div#" + aVideoModalDivId;
  this.myPlayer = null;
  this.myInstagramSearch = null;
  this.myYouTubeSearch = null;
  
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
  
  this.onInstagramMediaLoaded = function(anArrayOfMedia)
  {
    var theParentDiv = $(this.myContainerDiv);
    for (var i=0; i < anArrayOfMedia.length; i++) 
    {
      theParentDiv.append(this.generateMediaDivFromInstagram(anArrayOfMedia[i]))      
    };
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
    console.log("click");
  };

  this.onYouTubeMediaLoaded = function(anArrayOfMedia)
  {
    var theParentDiv = $(this.myContainerDiv);
    for (var i=0; i < anArrayOfMedia.length; i++) 
    {
      theParentDiv.append(this.generateMediaDivFromYouTube(anArrayOfMedia[i]))      
    };

    $(this.myVideoModalDiv + " a[data-dismiss]").click(createDelegate(this, this.onVideoDismiss))

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
