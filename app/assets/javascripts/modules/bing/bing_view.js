var BingView = function(aContainerDivSelector, 
                           aModalDivSelector, 
                           aPostDivSelector,
                           aYoutubeView)
{
  this.myContainerDiv = $(aContainerDivSelector);
  this.myDialogDiv = $(aModalDivSelector);
  this.myPostDiv = $(aPostDivSelector);
  this.myYoutubeView = aYoutubeView;
  
  this.myBingSearch = null;
  this.myBingVideos = {};
  this.myBingImages = {};
  this.myBingNews = {};
  this.myThumbnails = new Array();
  this.myElements = new Array();
  
  this.beginLoading = function(aTeamId)
  {
    this.myBingSearch = new BingSearch(this);
    this.myBingSearch.getSearchResultsForTeam(aTeamId);
  };
  
  this.cleanup = function()
  {
    if (this.myBingSearch)
    {
      this.myBingSearch.abort();
      this.myBingSearch = null;
    }

    this.cleanupThumbnails();

    this.myBingVideos = {};
    this.myBingImages = {};
    this.myBingNews = {};
  };
  
  this.queueContainerLoad = function( anElement )
  {
    this.myElements.push( anElement );
  };
  
  this.onBingResultsReady = function( anArrayOfVideos, anArrayOfImages, anArrayOfNews )
  {
    this.myBingVideos = anArrayOfVideos;
    this.myBingImages = anArrayOfImages;
    this.myBingNews = anArrayOfNews;
    
    for (var i=0, j=0; i < this.myBingNews.length && j < this.myElements.length; i++) 
    {
      this.createNewsThumbnail(this.myBingNews[i], this.myElements[j++]);
      this.createImageThumbnail(this.myBingImages[i], this.myElements[j++]);
      this.createVideoThumbnail(this.myBingVideos[i], this.myElements[j++]);
    };
  };
  
  this.onError = function(anError)
  {
    console.log(anError);
  };

  this.onSuccess = function()
  {
    
  };

  this.createNewsThumbnail = function(aNewsItem, anElement)
  {
    var theThumbnail = new BingNewsThumbnail(this);
    theThumbnail.initialize( aNewsItem, anElement );
    this.myThumbnails.push(theThumbnail);
  };  

  this.createImageThumbnail = function(anImageItem, anElement)
  {
    var theThumbnail = new BingImageThumbnail(this);
    theThumbnail.initialize( anImageItem, anElement );
    this.myThumbnails.push(theThumbnail);
  };  

  this.createVideoThumbnail = function(aVideoItem, anElement)
  {
    var theThumbnail = new BingVideoThumbnail(this);
    theThumbnail.initialize( aVideoItem, anElement );
    this.myThumbnails.push(theThumbnail);
  };  

  this.cleanupThumbnails = function()
  {
    for(var i=0,j=this.myThumbnails.length; i<j; i++)
    {
      this.myThumbnails[i].cleanup();
    };
    this.myThumbnails = new Array();
  };
  
  this.isYoutubeVideo = function( aUrl )
  {
    var thePattern = /.*youtube.com.*/i
    
    return thePattern.test(aUrl);
  };
  
  this.getIdFromYoutubeUrl = function( aUrl )
  {
    var thePattern = /v=(.*)$/ig
    return thePattern.exec(aUrl)[1];
  };
  
  this.loadBingVideo = function( aVideo )
  {
    if (this.isYoutubeVideo(aVideo.MediaUrl))
    {
      var theId = this.getIdFromYoutubeUrl( aVideo.MediaUrl );
      this.myYoutubeView.showVideoDialog(theId, aVideo.Title);
    }
    else
    {
      var theImageTag = "<img src='" + aVideo.Thumbnail.MediaUrl 
                        + "' width='" + aVideo.Thumbnail.Width 
                        + "' height='" + aVideo.Thumbnail.Height + "'/>";

      var theHtml = "<div class='bingVideo'>";
      theHtml += "<p><a href='" + aVideo.MediaUrl + "' target='blank'>Watch</a></p>";
      theHtml += "</div>";

      this.myDialogDiv.find("div.mediaImage").html(theImageTag);
      this.myDialogDiv.find("div.mediaCaption").html(theHtml);
      this.myDialogDiv.find("div.modal-header img").hide();
      
      this.myDialogDiv.find("#mediaImageData").show();
      this.myDialogDiv.find("#mediaVideoData").hide();    
    }
  };

  this.showDialog = function( aBingItem )
  {
    this.myDialogDiv.find("div.modal-header h3").text(aBingItem.Title);
    this.myDialogDiv.find("#post_media_button").data("bingItem", aBingItem).show();
    
    if (aBingItem.__metadata.type == "NewsResult")
    {
      var theHtml = "<div class='bingNews'>";
      theHtml += "<h4>" + aBingItem.Description + "</h4>";
      if (aBingItem.Source)
      {
        theHtml += "<p>Source : " + aBingItem.Source + "</p>";
      }
      theHtml += "<p>Link : <a href='" + aBingItem.Url + "' target='blank'>" + aBingItem.Url + "</a></p>";
      theHtml += "<p>When : <span class='timestamp' title='" + aBingItem.Date + "'>" + aBingItem.Date + "</span></p>";
      theHtml += "</div>";
      this.myDialogDiv.find("div.mediaImage").html("");
      this.myDialogDiv.find("div.mediaCaption").html(theHtml);
      this.myDialogDiv.find("div.modal-header img").hide();
      
      this.myDialogDiv.find("#mediaImageData").show();
      this.myDialogDiv.find("#mediaVideoData").hide();
      updateTimestamps();   
    }
    else if (aBingItem.__metadata.type == "VideoResult")
    {
      this.loadBingVideo(aBingItem);
    }
    else
    {
      var theImageTag = "<img src='" + aBingItem.MediaUrl + "' width='" + aBingItem.Width + "' height='" + aBingItem.Height + "'/>";
      var theAnchorTag = "Source: <a href='" + aBingItem.SourceUrl + "' target='_blank'>" + aBingItem.DisplayUrl + "</a>";
      this.myDialogDiv.find("div.mediaImage").html(theImageTag);
      this.myDialogDiv.find("div.mediaCaption").html(theAnchorTag);
      this.myDialogDiv.find("div.modal-header img").hide();

      this.myDialogDiv.find("#mediaImageData").show();
      this.myDialogDiv.find("#mediaVideoData").hide();
    }
    
    
    $(".modal").modal("hide");
    this.myDialogDiv.modal("show");
    
    trackEvent("MediaSlider", "bing_item_click", aBingItem.ID);    
  };
  
}
