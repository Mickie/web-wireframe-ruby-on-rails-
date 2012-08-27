var PhoneNavigator = function()
{
  this.myFacebookController = new FacebookController();
  this.myLeftNavOpenFlag = false;
  
  this.initialize = function()
  {
    this.registerHandlers("click");
    //this.registerHandlers("tap");
    
    this.adjustForDimensions();
  }
  
  this.registerHandlers = function( anEvent )
  {
    $("#showLeftNavButton").on( anEvent, createDelegate(this, this.onToggleLeftNav) );
    $('#frameContent').on( anEvent, '.fanzoneTile a', createDelegate(this, this.killEvent));
  }
  
  this.killEvent = function(e)
  {
    e.stopPropagation();
    e.preventDefault();
    return false;
  }  
  
  this.adjustForDimensions = function()
  {
    if (typeof window.device !== "undefined" )
    {
      this.onGapReady();
    }
    else
    {
      document.addEventListener('deviceready', createDelegate(this, this.onGapReady), false);
    }
    
    var theViewportWidth = window.outerWidth;
    var theViewportHeight = window.outerHeight;
    
    console.log("width: " + theViewportWidth + " height: " + theViewportHeight);
    
    $("#phoneUI").width(theViewportWidth).height(theViewportHeight);
    $("#phoneLeftNav").height(theViewportHeight);
    
    $("#phoneTileViewport").width(theViewportWidth).height(theViewportHeight);
    $("#phoneTileTopNav").width(theViewportWidth);
    $("#phoneTileContent").width(theViewportWidth).height(theViewportHeight - 40);

    $("#phoneFanzoneViewport").width(theViewportWidth).height(theViewportHeight).css("position", "absolute").css("left", theViewportWidth + "px");
    $("#phoneFanzoneTopNav").width(theViewportWidth);
    $("#phoneFanzoneContent").width(theViewportWidth).height(theViewportHeight - 70);
    $("#phoneFanzoneFooterNav").width(theViewportWidth);

  }
  
  this.showLogin = function()
  {
    this.myFacebookController.showLogin();
  }
  
  this.showAllFanzones = function()
  {
    this.getDataFromServer("/tailgates?noLayout=true")
    InfiniteScroller.get().handleScrollingForResource("/tailgates");
  }
  
  this.showMyFanzones = function()
  {
    this.getDataFromServer("/tailgates?filter=user&noLayout=true")
  }
  
  this.loadTailgate = function( aPath )
  {
    this.showFanzone();
    console.log("loading: " + aPath)
  }
  
  this.showFanzone = function()
  {
    $("#phoneTileViewport").addClass("closed");
    $("#phoneFanzoneViewport").show().addClass("open");
  }
  
  this.getDataFromServer = function( aPath )
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    $.ajax({
             url: aPath + "&authenticity_token=" + theToken,
             cache:false,
             dataType: "html",
             success: createDelegate(this, this.onLoadDataComplete ),
             error: createDelegate(this, this.onLoadError )
           });
  }
  
  this.onToggleLeftNav = function(e)
  {
    this.myLeftNavOpenFlag = !this.myLeftNavOpenFlag;
    
    if(this.myLeftNavOpenFlag)
    {
      $("#phoneLeftNav").show();
      $("#phoneTileViewport").addClass("open");
    }
    else
    {
      $("#phoneTileViewport").removeClass("open");
    }
  }
  
  this.onGapReady = function()
  {
    console.log("*************** yes ")
    alert("device:" + typeof window.device);
  }  
  
  this.onLoadDataComplete = function(aResult)
  {
    $("#frameContent").html(aResult);
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
