var UserManager = function()
{
  this.myFanzoAccountDetails = null;
  this.myFacebookModel = null;
  this.myFacebookController = new FacebookController();
  this.myObservers = new Array();
  this.myMobileFlag = false;
  this.myDeviceFlag = false;
  
  this.setAccountDetails = function( anAccountObject )
  {
    this.myFanzoAccountDetails = anAccountObject;
  }
  
  this.setMobile = function(aMobileFlag)
  {
    this.myMobileFlag = aMobileFlag;
  }
  
  this.setDevice = function(aDeviceFlag)
  {
    this.myDeviceFlag = aDeviceFlag;
  }
  
  this.onFacebookReady = function()
  {
    this.myFacebookController.initialize(this);
  }
  
  this.isLoggedIn = function()
  {
    return this.myFanzoAccountDetails != null;
  }
  
  this.isConnectedToTwitter = function()
  {
    return this.isLoggedIn() 
            && this.myFanzoAccountDetails.twitter_user_id
            && this.myFanzoAccountDetails.twitter_user_id.length > 0;
  }

  this.showTwitterModal = function()
  {
    this.notifyObservers("onShowConnectionModal");
    $("#myConnectTwitterModal").modal("show"); 
  };
  
  this.showFacebookModal = function()
  {
    this.notifyObservers("onShowConnectionModal");
    $("#myLoginModal").modal("show");
  };
  
  this.onFacebookLoginComplete = function( aFacebookModel )
  {
    this.myFacebookModel = aFacebookModel;
    
    if (!this.myFanzoAccountDetails && this.myMobileFlag)
    {
      this.loginToFanzo();
    }
  }
  
  this.loginToFanzo = function()
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    var theData = {"facebook_user_id": this.myFacebookModel.id, "facebook_access_token": this.myFacebookModel.token}
    $.ajax({
             type:"POST",
             data: theData,
             url: "/users/client_facebook_login.json?authenticity_token=" + theToken,
             cache:false,
             dataType: "json",
             success: createDelegate(this, this.onFanzoLoginComplete ),
             error: createDelegate(this, this.onFanzoLoginError )
           });
  }
  
  this.onFanzoLoginComplete = function( aResponse )
  {
    this.myFanzoAccountDetails = aResponse;
  }
  
  this.onFanzoLoginError = function( aResponse )
  {
    console.log(aResponse)
  }

  this.addObserver = function( anObserver )
  {
    this.myObservers.push(anObserver);
  }
  
  this.notifyObservers = function(aNotification, anArgumentsArray)
  {
    for(var i=0,j=this.myObservers.length; i<j; i++)
    {
      this.myObservers[i][aNotification].apply(this.myObservers[i], anArgumentsArray);
    };
  }
  
}

var myUserManager = new UserManager();
UserManager.get = function()
{
  return myUserManager;
}
