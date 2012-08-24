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

  this.onFacebookReady = function()
  {
    this.myFacebookController.initialize(this);
  }
  
  this.onLoggedIn = function()
  {
    $("#phoneLeftNav .login").hide();
    $("#phoneLeftNav .userProfile").show();
  }
  

}

var myPhoneNavigator = new PhoneNavigator();

$(function()
{
  myPhoneNavigator.initialize();
});
