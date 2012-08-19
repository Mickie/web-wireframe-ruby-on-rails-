var MediaSliderNew = function( aContainerDivSelector, aVideoModalDivSelector, anInstagramModalDivSelector, aPostDivSelector )
{
  var NUMBER_OF_VIEW_TYPES = 2;
  var TOTAL_CONTAINERS = NUMBER_OF_VIEW_TYPES*50;
  
  this.myContainerDivSelector = aContainerDivSelector;
  this.myVideoModalDivSelector = aVideoModalDivSelector;
  this.myInstagramModalDivSelector = anInstagramModalDivSelector;
  this.myPostDivSelector = aPostDivSelector;
  
  this.mySlideInterval = null;

  this.createSlider = function( aShortName,
                                aSport, 
                                anArrayOfHashTags,
                                anArrayOfInstagramTags )
  {
    this.myInstagramView = new InstagramView(this.myContainerDivSelector, this.myInstagramModalDivSelector, this.myPostDivSelector);
    this.myYoutubeView = new YoutubeView(this.myContainerDivSelector, this.myVideoModalDivSelector, this.myPostDivSelector);

    this.createMediaContainers();
    this.queueContainerLoads();

    this.myInstagramView.beginLoading(anArrayOfInstagramTags);
    this.myYoutubeView.beginLoading(aShortName, aSport, anArrayOfHashTags);
  };
  
  this.reset = function()
  {
    this.stopSliderTimer();
    
    $(this.myContainerDivSelector + " div#myMediaContent").clearQueue();
    $(this.myContainerDivSelector + " div#myMediaContent").stop();

    this.myInstagramView.cleanup();
    this.myInstagramView = null;
    
    this.myYoutubeView.cleanup();
    this.myYoutubeView = null;
  };
  
  this.createMediaContainers = function()
  {
    var theParentDiv = $(this.myContainerDiv + " div#myMediaContent");
    var theElement;

    for (var i = 0; i < TOTAL_CONTAINERS; i++)
    {
      theElement = $(this.myContainerDivSelector + " div#myMediaTemplate").clone();
      theParentDiv.append(theElement);
      this.myElementArray[i] = theElement;
    }
  };
  
  this.queueContainerLoads = function()
  {
    var i = 0;
    while(i < TOTAL_CONTAINERS)
    {
      this.myInstagramView.queueContainerLoad(this.myElementArray[i++]);
      this.myYoutubeView.queueContainerLoad(this.myElementArray[i++]);
    }
  }
  
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
  
}
