var MediaSlider = function( aContainerDivSelector, aModalDivSelector, aPostDivSelector )
{
  var SLIDE_INTERVAL = 5000;
  var NUMBER_OF_VIEW_TYPES = 6;
  var TOTAL_CONTAINERS = NUMBER_OF_VIEW_TYPES*15;
  
  this.myContainerDivSelector = aContainerDivSelector;
  this.myMediaModalDivSelector = aModalDivSelector;
  this.myPostDivSelector = aPostDivSelector;
  
  this.mySlideInterval = null;
  this.myScroller = null;
  this.myElementArray = {};

  this.createSlider = function( aShortName,
                                aSport, 
                                anArrayOfHashTags,
                                anArrayOfInstagramTags,
                                aTeamId )
  {
    this.myInstagramView = new InstagramView(this.myContainerDivSelector, this.myMediaModalDivSelector, this.myPostDivSelector);
    this.myYoutubeView = new YoutubeView(this.myContainerDivSelector, this.myMediaModalDivSelector, this.myPostDivSelector);
    this.myBingView = new BingView(this.myContainerDivSelector, this.myMediaModalDivSelector, this.myPostDivSelector, this.myYoutubeView);
    this.myAmazonView = new AmazonView(this.myContainerDivSelector, this.myMediaModalDivSelector, this.myPostDivSelector);

    this.createMediaContainers();
    this.queueContainerLoads();

    this.myInstagramView.beginLoading(anArrayOfInstagramTags);
    this.myYoutubeView.beginLoading(aShortName, aSport, anArrayOfHashTags);
    this.myBingView.beginLoading(aTeamId);
    this.myAmazonView.beginLoading(aTeamId);
    
    this.setupNavigation();
    this.startSliderTimer();    
  };
  
  this.reset = function()
  {
    this.stopSliderTimer();
    
    if (this.myScroller)
    {
      this.myScroller.destroy();
      this.myScroller = null;
    }

    if (this.myInstagramView)
    {
      this.myInstagramView.cleanup();
      this.myInstagramView = null;
    }

    if (this.myYoutubeView)
    {
      this.myYoutubeView.cleanup();
      this.myYoutubeView = null;
    }

    if (this.myBingView)
    {
      this.myBingView.cleanup();
      this.myBingView = null;
    }

    if (this.myAmazonView)
    {
      this.myAmazonView.cleanup();
      this.myAmazonView = null;
    }
  };
  
  this.createMediaContainers = function()
  {
    var theParentDiv = $(this.myContainerDivSelector + " div#myMediaContent");
    var theSpinnerOptions = {
      lines: 9,
      length: 0,
      width: 3,
      radius: 10,
      corners: 1,
      rotate: 0,
      trail: 50,
      speed: 1,
      left: 75
    } 

    for (var i = 0; i < TOTAL_CONTAINERS; i++)
    {
      var theElement = $(this.myContainerDivSelector + " div#myMediaTemplate").clone().attr("id", "");
      theParentDiv.append(theElement);
      if (i < 10)
      {
        theElement.spin(theSpinnerOptions, "red");
      }
      this.myElementArray[i] = theElement;
    }
  };
  
  this.queueContainerLoads = function()
  {
    var i = 0;

    while( i < TOTAL_CONTAINERS )
    {
      this.myInstagramView.queueContainerLoad(this.myElementArray[i++]);
      this.myYoutubeView.queueContainerLoad(this.myElementArray[i++]);
      this.myBingView.queueContainerLoad(this.myElementArray[i++]);
      this.myBingView.queueContainerLoad(this.myElementArray[i++]);
      this.myBingView.queueContainerLoad(this.myElementArray[i++]);
      this.myAmazonView.queueContainerLoad(this.myElementArray[i++]);
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
  
  this.isOldIE = function()
  {
    return !window.addEventListener;
  }
  
  this.patchIScrollForIE8 = function()
  {
    iScroll.prototype._bind = function (type, el, bubble) 
    {
      $(el || this.scroller).bind(type, createDelegate(this, this.handleEvent));
    };

    iScroll.prototype._unbind = function (type, el, bubble) 
    {
      $(el || this.scroller).bind(type, createDelegate(this, this.handleEvent));
    };
  }
  
  this.setupNavigation = function()
  {
    if (this.isOldIE())
    {
      this.patchIScrollForIE8();
    }
    else
    {
      $(this.myContainerDivSelector).hover(createDelegate(this, this.onHoverStart), createDelegate(this, this.onHoverEnd));
      $(this.myContainerDivSelector + " div#navigate_forward").click( createDelegate(this, this.onNavRight ) );
      $(this.myContainerDivSelector + " div#navigate_backward").click( createDelegate(this, this.onNavLeft ) );
    }
    
    
    this.myScroller = new iScroll("myMediaContainer",
                                  {
                                    vScroll: false,
                                    hScrollbar: false,
                                    vScrollbar: false,
                                    useTransform: true,
                                    bounce: false,
                                    snap: "div.mediaThumbnail",
                                    onScrollStart: createDelegate(this, this.onScrollStart),
                                    onScrollEnd: createDelegate(this, this.onScrollEnd)
                                  }); 
  }
  
  this.onSlideInterval = function()
  {
    if ( this.myScroller.currPageX < this.myScroller.pagesX.length )
    {
      this.myScroller.refresh();
      this.slideLeft();
    }
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
    this.myScroller.scrollToPage("next", 0, 600);
  };
  
  this.slideRight = function()
  {
    this.myScroller.scrollToPage("prev", 0, 600);
  };

  this.onScrollStart = function(e)
  {
    this.stopSliderTimer();
  }
  
  this.onScrollEnd = function(e)
  {
    this.startSliderTimer();    
  }
  
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

var myCurrentMediaSlider = null;
MediaSlider.create = function()
{
  if (myCurrentMediaSlider)
  {
    myCurrentMediaSlider.reset();
    return myCurrentMediaSlider;
  }
  
  myCurrentMediaSlider = new MediaSlider( "div#myMediaSlider",
                                          "div#myMediaModal",
                                          "div#postForm");
  
  return myCurrentMediaSlider;
};

