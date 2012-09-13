var DimensionManager = function()
{
  this.getDimensions = function()
  {
    if (UserManager.get().isMobile())
    {
      return this.getMobileDimensions();
    }
    return this.getDesktopDimensions();
  }
  
  this.getDesktopDimensions = function()
  {
    return {
      "width": $(window).width(),
      "height": $(window).height()
    }
  }
  
  this.getMobileDimensions = function()
  {
    var theViewportWidth;
    var theViewportHeight;
    
    switch(window.orientation) 
    {
      case -90:
      case 90:
      {
        theViewportWidth = 480;
        if (UserManager.get().isDevice())
        {
          theViewportHeight = 320;
        }
        else
        {
          theViewportHeight = 270;
        }
        break;
      }
      default:
      {
        theViewportWidth = 320;
        if (UserManager.get().isDevice())
        {
          theViewportHeight = 465;
        }
        else
        {
          theViewportHeight = 416;
        }
        break;
      }
    }
    
    return {
      "width": theViewportWidth,
      "height": theViewportHeight
    }
  }
}

var myDimensionManager = new DimensionManager();
DimensionManager.get = function()
{
  return myDimensionManager;
}
