var FacebookController = function()
{
  this.myListener = null;
  this.myFacebookId = null;
  this.myAccessToken = null;
  
  this.initialize = function( aListener )
  {
    this.myListener = aListener;
    
    FB.getLoginStatus(createDelegate(this, this.onLoginStatus));
    FB.Event.subscribe('auth.login', createDelegate(this, this.onLoginStatus));
    FB.Event.subscribe('auth.authResponseChange', createDelegate(this, this.onLoginStatus));
  };
  
  this.onLoginStatus = function(aResponse)
  {
    if (aResponse.status === 'connected')
    {
      var theFirstLoginFlag = !this.myFacebookId;
      this.myFacebookId = aResponse.authResponse.userID;
      this.myAccessToken = aResponse.authResponse.accessToken;
  
      if (theFirstLoginFlag)
      {
        this.myListener.onLoggedIn();
      }
    }
    else if (aResponse.status === 'not_authorized')
    {
      
    }
    else
    {
      
    }
  };
  
  this.postToFeed = function( aMessage, aResultCallback )
  {
    FB.api('/me/feed', 'post', { message: aMessage }, aResultCallback );
  }
  
}
