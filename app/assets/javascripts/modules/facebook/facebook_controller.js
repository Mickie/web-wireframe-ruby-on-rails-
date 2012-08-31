var FacebookController = function()
{
  this.myListener = null;
  this.myModel = new FacebookModel();
  
  this.initialize = function( aListener )
  {
    this.myListener = aListener;
    
    FB.getLoginStatus(createDelegate(this, this.onLoginStatus));
    FB.Event.subscribe('auth.login', createDelegate(this, this.onLoginStatus));
    FB.Event.subscribe('auth.authResponseChange', createDelegate(this, this.onLoginStatus));
  };
  
  this.showLogin = function()
  {
     FB.login(createDelegate(this, this.onLoginStatus), {scope: 'email, publish_stream'});
  };
  
  this.onLoginStatus = function(aResponse)
  {
    if (aResponse.status === 'connected')
    {
      var theFirstLoginFlag = !this.myModel.id;
      this.myModel.id = aResponse.authResponse.userID;
      this.myModel.token = aResponse.authResponse.accessToken;
  
      if (theFirstLoginFlag)
      {
        this.loadUserData();
      }
    }
    else
    {
      this.myListener.onLoggedOut();
    }
  };

  this.loadUserData = function()
  {
    FB.api('/me', createDelegate(this, this.onUserDataResponse));
  }
  
  this.onUserDataResponse = function( aResponse )
  {
    this.myModel.name = aResponse.name;
    this.myModel.first_name = aResponse.first_name;
    this.myModel.last_name = aResponse.last_name;
    this.myModel.facebook_user_data = aResponse;
    
    this.loginToFanzo();
  }
  
  this.loginToFanzo = function()
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    var theData = {"facebook_user_id": this.myModel.id, "facebook_access_token": this.myModel.token}
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
    this.myListener.onLoginComplete(this.myModel);
  }
  
  this.onFanzoLoginError = function( aResponse )
  {
    console.log(aResponse)
  }
  
  this.postToFeed = function( aMessage, aResultCallback )
  {
    FB.api('/me/feed', 'post', { message: aMessage }, aResultCallback );
  }
  
}
