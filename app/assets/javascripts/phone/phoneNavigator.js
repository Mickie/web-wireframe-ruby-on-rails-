var PhoneNavigator = function()
{
  var LEFT_NAV_OPEN = 1;
  var TILES_OPEN = 2;
  var FANZONE_OPEN = 3;
  
  this.myFacebookController = new FacebookController();
  this.myFanzoneView = new FanzoneView();
  this.myCurrentState = TILES_OPEN;
  
  this.initialize = function()
  {
    this.registerHandlers("click");
    //this.registerHandlers("tap");
    
    this.connectToPhoneGap();
    this.handleOrientationChanges();
    this.adjustForDimensions();
  }
  
  this.registerHandlers = function( anEvent )
  {
    $("#showLeftNavButton").on( anEvent, createDelegate(this, this.onToggleLeftNav) );
    $("#backToTilesButton").on( anEvent, createDelegate(this, this.onBackToTiles) );
    $('#frameContent').on( anEvent, '.fanzoneTile a', createDelegate(this, this.killEvent));
  }
  
  this.killEvent = function(e)
  {
    e.stopPropagation();
    e.preventDefault();
    return false;
  }
  
  this.handleOrientationChanges = function()
  {
    window.onorientationchange = createDelegate(this, this.adjustForDimensions);
  }
  
  this.connectToPhoneGap = function()
  {
    if (typeof window.device !== "undefined" )
    {
      this.onGapReady();
    }
    else
    {
      document.addEventListener('deviceready', createDelegate(this, this.onGapReady), false);
    }
  }
  
  this.getDimensions = function()
  {
    var theViewportWidth;
    var theViewportHeight;
    
    switch(window.orientation) 
    {
      case -90:
      case 90:
      {
        theViewportWidth = 480;
        theViewportHeight = 270;
        break;
      }
      default:
      {
        theViewportWidth = 320;
        theViewportHeight = 416;
        break;
      }
    }
    
    return {
      "width": theViewportWidth,
      "height": theViewportHeight
    }
  }
  
  
  this.adjustForDimensions = function()
  {
    var theDimensions = this.getDimensions();
    var theViewportWidth = theDimensions.width;
    var theViewportHeight = theDimensions.height;
    
    console.log("width: " + theViewportWidth + " height: " + theViewportHeight);
    
    $("#phoneUI").width(theViewportWidth).height(theViewportHeight);
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
  }
  
  this.loadTailgate = function( aPath )
  {
    this.showFanzone();
    this.myFanzoneView.loadTailgate( aPath );
  }
  
  this.loadTilesIntoFrameContent = function( aPath )
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    $.ajax({
             url: aPath + "&authenticity_token=" + theToken,
             cache:false,
             dataType: "html",
             success: createDelegate(this, this.onTileLoadComplete ),
             error: createDelegate(this, this.onLoadError )
           });
  }
  
  this.showLogin = function()
  {
    this.myFacebookController.showLogin();
  }
  
  this.showAllFanzones = function()
  {
    this.loadTilesIntoFrameContent("/tailgates?noLayout=true")
    InfiniteScroller.get().handleScrollingForResource("/tailgates");
    this.onToggleLeftNav();
  }
  
  this.showMyFanzones = function()
  {
    this.loadTilesIntoFrameContent("/tailgates?filter=user&noLayout=true")
    this.onToggleLeftNav();
  }
  
  this.showFanzone = function()
  {
    $("#phoneFanzoneViewport").show();
    $("#phoneFanzoneContent").hide();
    $("#phoneFanzoneLoading").show();

    this.positionFanzone();
    window.scrollTo(0, 1);

    this.myCurrentState = FANZONE_OPEN;
  }
  
  this.positionFanzone = function()
  {
    var theWidth = this.getDimensions().width;
    $("#phoneTileViewport").css("-webkit-transform", "translate3d(-" + theWidth + "px, 0px, 0px)");
    $("#phoneFanzoneViewport").css("-webkit-transform", "translate3d(-" + theWidth + "px, 0px, 0px)");
  }
  
  this.onBackToTiles = function(e)
  {
    $("#phoneTileViewport").css("-webkit-transform", "translate3d(0px, 0px, 0px)");
    $("#phoneFanzoneViewport").css("-webkit-transform", "translate3d(0px, 0px, 0px)");
    window.scrollTo(0, 1);
    
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
  
  this.onTileLoadComplete = function(aResult)
  {
    $("#frameContent").html(aResult);
    updateTimestamps();
  };
  
  this.onLoadError = function(anError)
  {
    console.log(anError);  
  };

  this.onFacebookReady = function()
  {
    this.myFacebookController.initialize(this);
  }
  
  this.onLoginComplete = function(aFacebookModel)
  {
    $("#leftNavUserPic").attr("src", aFacebookModel.getProfilePicUrl());
    $("#leftNavUserName").html(aFacebookModel.name);
    $("#phoneLeftNav .login").hide();
    $("#phoneLeftNav .userProfile").show();
    
  }
  
  this.onLoggedOut = function()
  {
    $("#phoneLeftNav .login").show();
    $("#phoneLeftNav .userProfile").hide();
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
