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
    
    this.myDialogDiv.on("click", "#post_media_button", createDelegate(this, this.onPostBingItem));
    this.myDialogDiv.on('hidden', createDelegate(this, this.onDialogHidden));    
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
      var theImageTag = "<img src='" + aVideo.Thumbnail.MediaUrl + "'/>";

      var theHtml = "<div class='bingVideo'>";
      theHtml += "<p><a href='" + aVideo.MediaUrl + "' target='_blank'>Watch: " + aVideo.Title + "</a></p>";
      theHtml += "<p>Location: " + aVideo.MediaUrl +  "</p>";
      theHtml += "</div>";

      this.myDialogDiv.find("div.mediaImage").html(theImageTag);
      this.myDialogDiv.find("div.mediaCaption").html(theHtml);
      this.myDialogDiv.find("div.modal-header img").hide();
      
      this.myDialogDiv.find("#mediaImageData").show();
      this.myDialogDiv.find("#mediaVideoData").hide();

      $(".modal").modal("hide");
      this.myDialogDiv.modal("show");
    }
  };
  
  this.loadBingNews = function( aNewsItem )
  {
    var theHtml = "<div class='bingNews'>";
    theHtml += "<h4>" + aNewsItem.Description + "</h4>";
    if (aNewsItem.Source)
    {
      theHtml += "<p>Source : " + aNewsItem.Source + "</p>";
    }
    theHtml += "<p>Link : <a href='" + aNewsItem.Url + "' target='_blank'>" + aNewsItem.Url + "</a></p>";
    theHtml += "<p>When : <span class='timestamp' title='" + aNewsItem.Date + "'>" + aNewsItem.Date + "</span></p>";
    theHtml += "</div>";
    this.myDialogDiv.find("div.mediaImage").html("");
    this.myDialogDiv.find("div.mediaCaption").html(theHtml);
    this.myDialogDiv.find("div.modal-header img").hide();
    
    this.myDialogDiv.find("#mediaImageData").show();
    this.myDialogDiv.find("#mediaVideoData").hide();
    
    updateTimestamps();   

    $(".modal").modal("hide");
    this.myDialogDiv.modal("show");
  };
  
  this.loadBingImage = function( anImageItem )
  {
    var theImageTag = "<img src='" + anImageItem.MediaUrl + "'/>";
    var theAnchorTag = "Source: <a href='" + anImageItem.SourceUrl + "' target='_blank'>" + anImageItem.DisplayUrl + "</a>";
    this.myDialogDiv.find("div.mediaImage").html(theImageTag);
    this.myDialogDiv.find("div.mediaCaption").html(theAnchorTag);
    this.myDialogDiv.find("div.modal-header img").hide();

    this.myDialogDiv.find("#mediaImageData").show();
    this.myDialogDiv.find("#mediaVideoData").hide();

    $(".modal").modal("hide");
    this.myDialogDiv.modal("show");
  };

  this.showDialog = function( aBingItem )
  {
    this.myDialogDiv.find("div.modal-header h3").text(aBingItem.Title);
    this.myDialogDiv.find("#post_media_button").data("bingItem", aBingItem).show();
    
    if (aBingItem.__metadata.type == "NewsResult")
    {
      this.loadBingNews( aBingItem );
    }
    else if (aBingItem.__metadata.type == "VideoResult")
    {
      this.loadBingVideo( aBingItem );
    }
    else
    {
      this.loadBingImage( aBingItem );
    }
    
    trackEvent("MediaSlider", "bing_item_click", aBingItem.__metadata.type);    
  };
  
  this.onDialogHidden = function(e)
  {
    this.myDialogDiv.find("#post_media_button").data("bingItem", null).hide();
  };
  
  this.onPostBingItem = function(e)
  {
    var theBingItem = $(e.target).data("bingItem");
    if (theBingItem)
    {
      if (theBingItem.__metadata.type == "NewsResult")
      {
        this.addBingNewsToPost( theBingItem );
      }
      else if (theBingItem.__metadata.type == "VideoResult")
      {
        this.addBingVideoToPost( theBingItem );
      }
      else
      {
        this.addBingImageToPost( theBingItem );
      }
      
      trackEvent("MediaSlider", "post_bingItem", theBingItem.__metadata.type);
      $(".modal").modal("hide");
    }

  };
  
  this.addBingNewsToPost = function( aBingNews )
  {
    var theBody = aBingNews.Title + "\n" + aBingNews.Description + "...\n\n" + aBingNews.Url;
    var theHeader = "Cool article from " + aBingNews.Source + ":\n\n";
    
    this.myPostDiv.find("#post_content").val( theHeader + theBody );
  };

  this.addBingVideoToPost = function( aBingVideo )
  {
    if (this.isYoutubeVideo( aBingVideo.MediaUrl ))
    {
      var theVideoId = this.getIdFromYoutubeUrl( aBingVideo.MediaUrl );
      var theThumbnailUrl = aBingVideo.Thumbnail.MediaUrl;
          
      this.myYoutubeView.addYoutubeVideoToPost( theVideoId, theThumbnailUrl );  
    }
    else
    {
      var theBody = aBingVideo.MediaUrl;
      var theHeader = "Cool video: " + aBingVideo.Title + "\n\n";
      
      this.myPostDiv.find("#post_content").val( theHeader + theBody );
      this.myPostDiv.find("#post_image_url").val(aBingVideo.Thumbnail.MediaUrl);
      this.myPostDiv.find("#post_video_id").val("");
      this.myPostDiv.find(".media_container").html("<img src='" + aBingVideo.Thumbnail.MediaUrl + "' width='160'/>");
      this.myPostDiv.find(".media_preview").slideDown(600);
    }
    
  };

  this.addBingImageToPost = function( aBingImage )
  {
    this.myPostDiv.find("#post_image_url").val(aBingImage.MediaUrl);
    this.myPostDiv.find("#post_video_id").val("");
    this.myPostDiv.find(".media_container").html("<img src='" + aBingImage.MediaUrl + "' width='306'/>");
    this.myPostDiv.find(".media_preview").slideDown(600);
  };

}
