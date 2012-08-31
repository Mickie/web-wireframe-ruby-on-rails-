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
  
  this.getUserId = function()
  {
    if (this.isLoggedIn())
    {
      return this.myFanzoAccountDetails.id;
    }
    
    return nil;
  }
  
  this.getProfilePicUrl = function()
  {
    if (this.isLoggedIn())
    {
      return "https://graph.facebook.com/" + this.myFanzoAccountDetails.facebook_user_id + "/picture?type=square";
    }
    
    return this.myFacebookModel.getProfilePicUrl();
  }
  
  this.getCommentVote = function( aCommentId )
  {
    for (var i = 0; i < this.myFanzoAccountDetails.user_comment_votes.length; i++)
    {
      if (this.myFanzoAccountDetails.user_comment_votes[i].comment_id == aCommentId )
      {
        return this.myFanzoAccountDetails.user_comment_votes[i];
      }
    }
    return null;
  }
  
  this.addCommentVote = function(aVote)
  {
    this.myFanzoAccountDetails.user_comment_votes.push(aVote);
  }

  this.getPostVote = function( aPostId )
  {
    for (var i = 0; i < this.myFanzoAccountDetails.user_post_votes.length; i++)
    {
      if (this.myFanzoAccountDetails.user_post_votes[i].post_id == aPostId )
      {
        return this.myFanzoAccountDetails.user_post_votes[i];
      }
    }
    return null;
  }
  
  this.addPostVote = function(aVote)
  {
    this.myFanzoAccountDetails.user_post_votes.push(aVote);
  }
  
  this.isMyTailgate = function(aTailgateId)
  {
    if (this.isLoggedIn())
    {
      for (var i=0; i < this.myFanzoAccountDetails.tailgates.length; i++) 
      {
        if (this.myFanzoAccountDetails.tailgates[i].id == aTailgateId)
        {
          return true;
        }
      }
    }
    
    return false;
  }

  this.isTailgateIFollow = function(aTailgateId)
  {
    if (this.isLoggedIn())
    {
      for (var i=0; i < this.myFanzoAccountDetails.followed_tailgates.length; i++) 
      {
        if (this.myFanzoAccountDetails.followed_tailgates[i].id == aTailgateId)
        {
          return true;
        }
      }
    }
    
    return false;
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
  
  this.showFacebookLogin = function()
  {
    this.myFacebookController.showLogin();      
  };

  this.onFacebookLoginComplete = function( aFacebookModel )
  {
    this.myFacebookModel = aFacebookModel;
    
    if (!this.myFanzoAccountDetails && this.myMobileFlag)
    {
      this.loginToFanzo();
    }
  }
  
  this.onFacebookLoggedOut = function()
  {
    $("#phoneLeftNav .login").show();
    $("#phoneLeftNav .userProfile").hide();
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

    $("#leftNavUserPic").attr("src", aFacebookModel.getProfilePicUrl());
    $("#leftNavUserName").html(aFacebookModel.name);
    $("#phoneLeftNav .login").hide();
    $("#phoneLeftNav .userProfile").show();
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
