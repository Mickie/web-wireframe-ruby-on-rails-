var VenueSlider = function()
{
  this.myVenueSelector; 
  
  this.initialize = function(aVenueSelector)
  {
    this.myVenueSelector = aVenueSelector;
    this.setupPicker();
  }
  
  this.setupPicker = function()
  {
    $(this.myVenueSelector).find(".dropdown-menu").dropdown();
    $(this.myVenueSelector).find('.dropdown-menu a').click(createDelegate(this, this.onMenuSelect));
  }
  
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
