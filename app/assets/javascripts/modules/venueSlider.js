var VenueSlider = function()
{
  this.myVenueSelector;
  this.myScroller;
  
  this.initialize = function(aVenueSelector)
  {
    this.myVenueSelector = aVenueSelector;
    this.setupPicker();
    this.setupScroller();
  }
  
  this.setupPicker = function()
  {
    $(this.myVenueSelector).find(".dropdown-menu").dropdown();
    $(this.myVenueSelector).find('.dropdown-menu').on("click", "a", createDelegate(this, this.onMenuSelect));
  }
  
  this.setupScroller = function()
  {
    this.myScroller = new iScroll("venueScroller",
                                  {
                                    vScroll: false,
                                    hScrollbar: false,
                                    vScrollbar: false,
                                    useTransform: true,
                                    bounce: false,
                                    snap: "div.venue"
                                  }); 
    EventManager.get().addObserver("onVenueListChanged", this);
    
    
    $(this.myVenueSelector).hover(createDelegate(this, this.onHoverStart), createDelegate(this, this.onHoverEnd));
    $(this.myVenueSelector + " div#scrollLeft").click( createDelegate(this, this.onScrollLeft ) );
    $(this.myVenueSelector + " div#scrollRight").click( createDelegate(this, this.onScrollRight ) );
  }
  
  this.onVenueListChanged = function()
  {
    this.myScroller.refresh();
    this.myScroller.scrollToPage(0,0,5);
  }
  
  this.onScrollLeft = function(e)
  {
    this.myScroller.scrollToPage("prev", 0, 600);
  }
  
  this.onScrollRight = function(e)
  {
    this.myScroller.scrollToPage("next", 0, 600);
  }
  
  this.onHoverStart = function(e)
  {
    $(this.myVenueSelector + " div#scrollerControls").fadeIn(500);
  };
  
  this.onHoverEnd = function(e)
  {
    $(this.myVenueSelector + " div#scrollerControls").fadeOut(500);
  };

  this.onMenuSelect = function(e)
  {
    if (e.target.parentNode.nodeName == "FORM")
    {
      var theLocation = $(e.target).text();
      $(this.myVenueSelector).find(".currentLocation").text(theLocation);
      $.rails.handleRemote($(e.target.parentElement));
    }
    else
    {
      var theSelector = $(e.target).attr("href");
      $(theSelector).modal();
    }
  }
}

var mySingleVenueSlider = new VenueSlider();

VenueSlider.get = function()
{
  return mySingleVenueSlider;
}
