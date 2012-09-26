var VenueSlider = function()
{
  this.myVenueSelector; 
  
  this.initialize = function(aVenueSelector)
  {
    this.myVenueSelector = aVenueSelector;
    this.enablePickerDropdown();
  }
  
  this.enablePickerDropdown = function()
  {
    $(this.myVenueSelector).find(".dropdown-menu").dropdown();
  }
}

var mySingleVenueSlider = new VenueSlider();

VenueSlider.get = function()
{
  return mySingleVenueSlider;
}
