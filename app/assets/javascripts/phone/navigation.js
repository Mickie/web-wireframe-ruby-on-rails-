var PhoneNavigator = function()
{
  this.myLeftNavOpenFlag = false;
  
  this.initializeTopNav = function()
  {
    $("#showLeftNavButton").click( createDelegate(this, this.onToggleLeftNav) );
  }
  
  this.onToggleLeftNav = function(e)
  {
    this.myLeftNavOpenFlag = !this.myLeftNavOpenFlag;
    
    if(this.myLeftNavOpenFlag)
    {
      $("#phoneViewport").animate({ "left": "260px" }, 200);
    }
    else
    {
      $("#phoneViewport").animate({ "left": "0px" }, 200);
    }
  }
}

var myPhoneNavigator = new PhoneNavigator();

$(function(){
  myPhoneNavigator.initializeTopNav();
});
