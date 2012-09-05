var FanzoneView = function()
{
  this.myTailgateModel = {};
  this.myFanzonePostsController = FanzonePostsController.create("#postsAndComments");
  this.myFanzoneHomeView = new FanzoneHomeView();
  
  this.initialize = function()
  {
  }
  
  this.loadTailgate = function( aPath )
  {
    var thePath = aPath + ".json";
    this.loadTailgateIntoFanzoneView( thePath );
  }
  
  this.cleanup = function()
  {
    this.myFanzoneHomeView.cleanup();
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
  

  this.onTailgateLoadComplete = function( aResult )
  {
    this.myTailgateModel = aResult;
    
    $("#phoneFanzoneContent").show();
    $("#phoneFanzoneLoading").hide();

    this.renderBanner();
    this.renderFollowButton();  
    this.renderPostForm();
    this.myFanzoneHomeView.render(this.myTailgateModel);
    
    updateTimestamps();
    
    this.myFanzonePostsController.initialize(this.myTailgateModel.team.sport_id, this.myTailgateModel.topic_tags);
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
          return "<img src='" + UserManager.get().getProfilePicUrl() + "' width='24' height='24' />";
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
      ".description" : "description",
      ".profile_pic img@src" : "user.image",
      ".owner_name" : "user.first_name",
      ".timestamp@title" : "created_at",
      ".timestamp" : "created_at",
      ".team_logo img@src" : function(anItem)
      {
        var theSlug = anItem.context.team.slug;
        return "http://fanzo_static.s3.amazonaws.com/logos/" + theSlug + "_m.gif";
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
