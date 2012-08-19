var MediaSlider = function( aContainerDivSelector, aVideoModalDivSelector, anInstagramModalDivSelector, aPostDivSelector )
{
  var SLIDE_INTERVAL = 5000;
  var NUMBER_OF_VIEW_TYPES = 2;
  var TOTAL_CONTAINERS = NUMBER_OF_VIEW_TYPES*20;
  
  this.myContainerDivSelector = aContainerDivSelector;
  this.myVideoModalDivSelector = aVideoModalDivSelector;
  this.myInstagramModalDivSelector = anInstagramModalDivSelector;
  this.myPostDivSelector = aPostDivSelector;
  
  this.mySlideInterval = null;
  this.myElementArray = {};

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
    
    this.setupNavigation();
    this.startSliderTimer();    
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
    var theParentDiv = $(this.myContainerDivSelector + " div#myMediaContent");

    for (var i = 0; i < TOTAL_CONTAINERS; i++)
    {
      var theElement = $(this.myContainerDivSelector + " div#myMediaTemplate").clone().attr("id", "");
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
    this.mySlideInterval = setInterval(createDelegate(this, this.onSlideInterval), SLIDE_INTERVAL);
  };

  this.stopSliderTimer = function()
  {
    if (this.mySlideInterval)
    {
      clearInterval(this.mySlideInterval);
    }
    this.mySlideInterval = null;
  };
  
  
  this.setupNavigation = function()
  {
    $(this.myContainerDivSelector).hover(createDelegate(this, this.onHoverStart), createDelegate(this, this.onHoverEnd));
    $(this.myContainerDivSelector + " div#navigate_forward").click( createDelegate(this, this.onNavRight ) );
    $(this.myContainerDivSelector + " div#navigate_backward").click( createDelegate(this, this.onNavLeft ) );
  }
  
  this.onSlideInterval = function()
  {
    this.slideLeft();
  };
  
  this.onNavRight = function(e)
  {
    this.slideRight();
    trackEvent("MediaSlider", "navRight");    
  };

  this.onNavLeft = function(e)
  {
    this.slideLeft();
    trackEvent("MediaSlider", "navLeft");    
  };

  this.slideLeft = function()
  {
    this.stopSliderTimer();
    var theLeftMostDivImageWidth = $(this.myContainerDivSelector + " div#myMediaContent div:first img").attr("width");
    $(this.myContainerDivSelector + " div#myMediaContent").animate({ left:"-" + theLeftMostDivImageWidth + "px"}, 
                                                                500, 
                                                                'linear', 
                                                                createDelegate(this, this.onSlideLeftComplete) );
  };
  
  this.slideRight = function()
  {
    this.stopSliderTimer();
    var theRightMostDiv = $(this.myContainerDivSelector + " div#myMediaContent div.mediaThumbnail:last").detach();
    if (theRightMostDiv)
    {
      var theImageWidth = $(theRightMostDiv).find("img").attr("width");
      $(this.myContainerDivSelector + " div#myMediaContent").prepend(theRightMostDiv);
      $(this.myContainerDivSelector + " div#myMediaContent").css({left:"-" + theImageWidth + "px"});
      $(this.myContainerDivSelector + " div#myMediaContent").animate({ left:"0px"}, 
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
    var theLeftMostDiv = $(this.myContainerDivSelector + " div#myMediaContent div:first").detach();
    if (theLeftMostDiv)
    {
      $(this.myContainerDivSelector + " div#myMediaContent").append(theLeftMostDiv);
      $(this.myContainerDivSelector + " div#myMediaContent").css({left:"0px"});
      this.startSliderTimer();    
    }
  };
  
  this.onHoverStart = function(e)
  {
    this.stopSliderTimer();
    $(this.myContainerDivSelector + " div#navigate_forward").fadeIn(500);
    $(this.myContainerDivSelector + " div#navigate_backward").fadeIn(500);
  };
  
  this.onHoverEnd = function(e)
  {
    this.startSliderTimer();
    $(this.myContainerDivSelector + " div#navigate_forward").fadeOut(500);
    $(this.myContainerDivSelector + " div#navigate_backward").fadeOut(500);
  };
  
};

var myOnlyMediaSlider = null;
MediaSlider.create = function()
{
  if (myOnlyMediaSlider)
  {
    myOnlyMediaSlider.reset();
    return myOnlyMediaSlider;
  }
  
  myOnlyMediaSlider = new MediaSlider( "div#myMediaSlider", 
                                          "div#myVideoModal",
                                          "div#myInstagramModal",
                                          "div#postForm");
  
  return myOnlyMediaSlider;
};

