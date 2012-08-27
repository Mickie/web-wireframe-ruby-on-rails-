var PhoneNavigator = function()
{
  this.myFacebookController = new FacebookController();
  this.myLeftNavOpenFlag = false;
  
  this.initialize = function()
  {
    $("#showLeftNavButton").on( "click", createDelegate(this, this.onToggleLeftNav) );
    //$("#showLeftNavButton").on( "tap", createDelegate(this, this.onToggleLeftNav) );
    
    this.adjustForDimensions();
  }
  
  this.onGapReady = function()
  {
    console.log("*************** yes ")
    alert("device:" + typeof window.device);
  }
  
  this.adjustForDimensions = function()
  {
    if (typeof window.device !== "undefined" )
    {
      onGapReady();
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
    $("#phoneTopNav").width(theViewportWidth);
    $("#phoneFooterNav").width(theViewportWidth);
    $("#phoneViewport").width(theViewportWidth).height(theViewportHeight);
    $("#phoneContent").width(theViewportWidth).height(theViewportHeight - 70);
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
      $("#phoneViewport").addClass("open");
    }
    else
    {
      $("#phoneViewport").removeClass("open");
    }
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

$(function()
{
  myPhoneNavigator.initialize();
});
