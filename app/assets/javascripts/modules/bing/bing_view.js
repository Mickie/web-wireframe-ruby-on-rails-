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
  this.myElements = new Array();
  
  this.beginLoading = function(aTeamId)
  {
    this.myBingSearch = new BingSearch(this);
    this.myBingSearch.getSearchResultsForTeam(aTeamId);
  };
  
  this.cleanup = function()
  {
    this.myBingSearch.abort();
    this.myBingSearch = null;

    this.myYouTubeVideos = {};
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

  this.createNewsThumbnail = function(aNewsItem, anElement)
  {
    
  };  

  this.createImageThumbnail = function(anImageItem, anElement)
  {
    
  };  

  this.createVideoThumbnail = function(aVideoItem, anElement)
  {
    
  };  

}
