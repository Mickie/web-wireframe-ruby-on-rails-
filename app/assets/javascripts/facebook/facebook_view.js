var FacebookView = function()
{
  this.initialize = function()
  {
    FB.getLoginStatus(createDelegate(this, this.onLoginStatus));
    FB.Event.subscribe('auth.login', createDelegate(this, this.onLoginStatus));
    FB.Event.subscribe('auth.authResponseChange', createDelegate(this, this.onLoginStatus));
  };
  
  this.onLoginStatus = function(aResponse)
  {
    if (aResponse.status === 'connected')
    {
      this.myFacebookId = aResponse.authResponse.userID;
      this.myAccessToken = aResponse.authResponse.accessToken;
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
