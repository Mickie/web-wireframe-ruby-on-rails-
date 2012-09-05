var FanzoneView = function()
{
  this.myTailgateModel = {};
  this.myFanzoneScroller = null;
  this.myFanzonePostsController = FanzonePostsController.create("#postsAndComments");
  this.myFanzoneHomeView = new FanzoneHomeView();
  this.myFanzoneSocialView = new FanzoneSocialView();
  
  this.initialize = function()
  {
    $("#fanzoneFooterHome").click(createDelegate(this, this.onHomeClicked));
    $("#fanzoneFooterSocial").click(createDelegate(this, this.onSocialClicked));
    $("#fanzoneFooterMedia").click(createDelegate(this, this.onMediaClicked));
    $("#fanzoneFooterMap").click(createDelegate(this, this.onMapClicked));
  }
  
  this.loadTailgate = function( aPath )
  {
    var thePath = aPath + ".json";
    this.loadTailgateIntoFanzoneView( thePath );
    this.onHomeClicked();
  }
  
  this.cleanup = function()
  {
    this.myFanzoneHomeView.cleanup();
    this.myFanzoneSocialView.cleanup();
    this.cleanupFanzoneScroller();
  }
  
  this.loadTailgateIntoFanzoneView = function( aPath )
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    $.ajax({
             url: aPath + "?authenticity_token=" + theToken,
             cache:false,
             dataType: "json",
             success: createDelegate(this, this.onTailgateLoadComplete ),
             error: createDelegate(this, this.onLoadError )
           });
  }
  
  this.setupFanzoneScroller = function()
  {
    this.myFanzoneScroller = new iScroll("phoneFanzoneContent",
                                        {
                                          useTransform: true,
                                          onBeforeScrollStart: enableFormsOnBeforeScroll 
                                        });
    document.addEventListener('touchmove', killEvent, false);
  }
  
  this.cleanupFanzoneScroller = function()
  {
    this.myFanzoneScroller.destroy()
    this.myFanzoneScroller = null;
    document.removeEventListener('touchmove', killEvent, false);
  }
  

  this.onTailgateLoadComplete = function( aResult )
  {
    this.myTailgateModel = aResult;
    
    $("#phoneFanzoneContent").show();
    $("#phoneFanzoneLoading").hide();

    this.renderBanner();
    this.renderFollowButton();  
    this.renderPostForm();
    this.setupFanzoneScroller();

    this.myFanzoneHomeView.render(this.myTailgateModel, this.myFanzoneScroller);
    this.myFanzonePostsController.initialize(this.myTailgateModel.team.sport_id, this.myTailgateModel.topic_tags);
    this.myFanzoneSocialView.render(this.myTailgateModel, this.myFanzonePostsController);

    updateTimestamps();
  };
  
  this.onLoadError = function(anError)
  {
    console.log(anError);  
  };
  
  this.onFollow = function(e)
  {
    alert("follow")
  }
  
  this.onUnfollow = function(e)
  {
    alert("unfollow")
  }
  
  this.onHomeClicked = function(e)
  {
    $("#posts").show();
    $("#tweetHolder").hide();
    this.myFanzoneScroller.refresh();
  }
  
  this.onSocialClicked = function(e)
  {
    $("#posts").hide();
    $("#tweetHolder").show();
    this.myFanzoneScroller.refresh();
  }
  
  this.onMediaClicked = function(e)
  {
    
  }
  
  this.onMapClicked = function(e)
  {
    
  }
  
  this.renderBanner = function()
  {
    $("#phoneFanzoneBanner").render(this.myTailgateModel, this.getBannerDirective());
  }
  
  this.renderFollowButton = function()
  {
    var theUserManager = UserManager.get();
    if (theUserManager.isLoggedIn())
    {
      if ( theUserManager.isMyTailgate( this.myTailgateModel.id ))
      {
        $("#followButton").hide();
      }
      else if ( theUserManager.isTailgateIFollow( this.myTailgateModel.id ) )
      {
        $("#followButton").text("Unfollow").click( createDelegate( this, this.onUnfollow ) ).show();
      }
      else
      {
        $("#followButton").text("Follow").click( createDelegate( this, this.onFollow ) ).show();
      }
    }
    else
    {
      $("#followButton").text("Follow").click( createDelegate( theUserManager, theUserManager.showFacebookModal ) ).show();
    }
  }
  
  this.renderPostForm = function()
  {
    $("#postForm").render(this.myTailgateModel, this.getPostFormDirective());
  }
  
  this.getPostFormDirective = function()
  {
    return {
      "#postForm .profile_pic": function(anItem)
      {
        if (UserManager.get().isLoggedIn())
        {
          return "<img src='" + UserManager.get().getProfilePicUrl() + "' width='32' height='32' />";
        }
        return "";
      },
      "#new_post@action" : function(anItem)
      {
        return "/tailgates/" + anItem.context.slug + "/posts";
      }      
    }
  }
  
  this.getBannerDirective = function()
  {
    var theThis = this;
    return {
      ".fanzoneName": "name",
      ".owner_name" : "user.first_name",
      ".team_logo img@src" : function(anItem)
      {
        var theSlug = anItem.context.team.slug;
        return "http://fanzo_static.s3.amazonaws.com/logos/" + theSlug + "_s.gif";
      },
      ".official@style": function(anItem)
      {
        return anItem.context.official ? "display:block" : "display:none";
      },
      ".banner_content@style": function(anItem)
      {
        return "background-color:" + anItem.context.color;
      }
    }
  };
  
  
}
