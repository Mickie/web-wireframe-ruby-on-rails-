var PhoneNavigator = function()
{
  this.myFacebookController = new FacebookController();
  this.myLeftNavOpenFlag = false;
  
  this.initialize = function()
  {
    $("#showLeftNavButton").on( "click", createDelegate(this, this.onToggleLeftNav) );
    //$("#showLeftNavButton").on( "tap", createDelegate(this, this.onToggleLeftNav) );
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
  
  this.showLogin = function()
  {
    this.myFacebookController.showLogin();
  }

  this.onFacebookReady = function()
  {
    this.myFacebookController.initialize(this);
  }
  
  this.onLoginComplete = function(aFacebookModel)
  {
    $("#phoneLeftNav .userPic").attr("src", aFacebookModel.getProfilePicUrl());
    $("#phoneLeftNav .userName").html(aFacebookModel.name);
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
