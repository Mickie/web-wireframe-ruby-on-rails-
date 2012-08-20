var BingView = function(aContainerDivSelector, 
                           aModalDivSelector, 
                           aPostDivSelector)
{
  this.myContainerDiv = $(aContainerDivSelector);
  this.myDialogDiv = $(aModalDivSelector);
  this.myPostDiv = $(aPostDivSelector);
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
  
  this.bingResultsReady = function( anArrayOfVideos, anArrayOfImages, anArrayOfNews )
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
    var theThumbnail = new BingNewsThumbnail(this);
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

  this.showDialog = function( aBingItem )
  {
    this.myDialogDiv.find("div.modal-header h3").text(aBingItem.Title);
    this.myDialogDiv.find("#post_image_button").data("bingItem", aBingItem).show();
    
    $(".modal").modal("hide");
    this.myDialogDiv.modal("show");
    
    trackEvent("MediaSlider", "bing_item_click", aBingItem.ID);    
  };
  
}
