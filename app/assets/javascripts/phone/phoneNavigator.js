var PhoneNavigator = function()
{
  var LEFT_NAV_OPEN = 1;
  var TILES_OPEN = 2;
  var FANZONE_OPEN = 3;
  
  this.myFanzoneView;
  this.myTilesView;
  this.myCurrentState = TILES_OPEN;
  
  this.initialize = function()
  {
    this.myFanzoneView = new FanzoneView();
    this.myTilesView = new TilesView();

    this.registerHandlers("click");
    //this.registerHandlers("tap");
    
    this.connectToPhoneGap();
    this.handleOrientationChanges();
    this.adjustForDimensions();
    this.myTilesView.initialize();
    this.myFanzoneView.initialize();
  }
  
  this.registerHandlers = function( anEvent )
  {
    $("#showLeftNavButton").on( anEvent, createDelegate(this, this.onToggleLeftNav) );
    $("#backToTilesButton").on( anEvent, createDelegate(this, this.onBackToTiles) );
    $('#frameContent').on( anEvent, '.fanzoneTile a', killEvent);
  }
  
  this.handleOrientationChanges = function()
  {
    window.onorientationchange = createDelegate(this, this.adjustForDimensions);
  }
  
  this.connectToPhoneGap = function()
  {
    if ( UserManager.get().isDevice() )
    {
      this.onGapReady();
    }
    else
    {
      document.addEventListener('deviceready', createDelegate(this, this.onGapReady), false);
    }
  }
  
  this.adjustForDimensions = function()
  {
    var theDimensions = DimensionManager.get().getDimensions();
    var theViewportWidth = theDimensions.width;
    var theViewportHeight = theDimensions.height;
    
    console.log("width: " + theViewportWidth + " height: " + theViewportHeight);
    
    $(".phoneUI").width(theViewportWidth).height(theViewportHeight);
    $("#phoneLeftNav").height(theViewportHeight);
    
    $("#phoneTileViewport").width(theViewportWidth).height(theViewportHeight);
    $("#phoneTileTopNav").width(theViewportWidth);
    $("#phoneTileContent").width(theViewportWidth).height(theViewportHeight - 30);

    $("#phoneFanzoneViewport").width(theViewportWidth).height(theViewportHeight).css("position", "absolute").css("left", theViewportWidth + "px");
    $("#phoneFanzoneTopNav").width(theViewportWidth);
    $("#phoneFanzoneContent").width(theViewportWidth).height(theViewportHeight - 70);
    $("#phoneFanzoneFooterNav").width(theViewportWidth);
    $("#phoneFanzoneFooterNav").css("top", (theViewportHeight - 40) + "px");
    
    if (this.myCurrentState == FANZONE_OPEN)
    {
      this.positionFanzone();
    }
    window.scrollTo(0, 1);
  }
  
  this.loadTailgate = function( aPath )
  {
    this.showFanzone();
    this.myFanzoneView.loadTailgate( aPath );
  }
  
  this.showAllFanzones = function()
  {
    this.myTilesView.loadAllFanzones();
    this.onToggleLeftNav();
  }
  
  this.showMyFanzones = function()
  {
    this.myTilesView.loadMyFanzones();
    this.onToggleLeftNav();
  }
  
  this.showFanzone = function()
  {
    $("#phoneFanzoneViewport").show();
    $("#phoneFanzoneContent").hide();
    $("#phoneFanzoneLoading").show();

    this.myTilesView.onHidden();
    this.positionFanzone();
    window.scrollTo(0, 1);

    this.myCurrentState = FANZONE_OPEN;
  }
  
  this.positionFanzone = function()
  {
    var theWidth = DimensionManager.get().getDimensions().width;
    $("#phoneTileViewport").css("-webkit-transform", "translate3d(-" + theWidth + "px, 0px, 0px)");
    $("#phoneFanzoneViewport").css("-webkit-transform", "translate3d(-" + theWidth + "px, 0px, 0px)");
  }
  
  this.onBackToTiles = function(e)
  {
    $("#phoneTileViewport").css("-webkit-transform", "translate3d(0px, 0px, 0px)");
    $("#phoneFanzoneViewport").css("-webkit-transform", "translate3d(0px, 0px, 0px)");
    $("#followButton").hide();

    window.scrollTo(0, 1);
    this.myFanzoneView.cleanup();
    this.myTilesView.onShown();
    
    this.myCurrentState = TILES_OPEN;
  }

  this.onToggleLeftNav = function(e)
  {
    if(this.myCurrentState == TILES_OPEN)
    {
      this.myCurrentState = LEFT_NAV_OPEN;
      $("#phoneLeftNav").show();
      $("#phoneTileViewport").css("-webkit-transform", "translate3d(260px, 0px, 0px)");
    }
    else
    {
      this.myCurrentState = TILES_OPEN;
      $("#phoneTileViewport").css("-webkit-transform", "translate3d(0px, 0px, 0px)");
    }

    window.scrollTo(0, 1);
    
    return false;
  }
  
  this.onGapReady = function()
  {
    console.log("*************** yes ")
    alert("device:" + typeof window.device);
  }  
  
}

var myPhoneNavigator = new PhoneNavigator();

function loadData(aPath, aNewActiveSelector)
{
  myPhoneNavigator.loadTailgate( aPath );
  return false;
}


$(function()
{
  myPhoneNavigator.initialize();
});
