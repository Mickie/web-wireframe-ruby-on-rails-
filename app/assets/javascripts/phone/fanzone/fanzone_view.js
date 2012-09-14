var FanzoneView = function()
{
  this.myTailgateModel = {};
  this.myFanzoneScroller = null;
  this.myFanzonePostsController = FanzonePostsController.create("#postsAndComments");
  this.myFanzoneHomeView = new FanzoneHomeView();
  this.myFanzoneSocialView = new FanzoneSocialView();
  this.myFanzoneMediaView = new FanzoneMediaView();
  this.myAbortFlag = false;
  
  this.initialize = function()
  {
    $("#fanzoneFooterHome").click(createDelegate(this, this.onHomeClicked));
    $("#fanzoneFooterSocial").click(createDelegate(this, this.onSocialClicked));
    $("#fanzoneFooterMedia").click(createDelegate(this, this.onMediaClicked));
  }
  
  this.loadTailgate = function( aPath )
  {
    this.myAbortFlag = false;
    var thePath = aPath + ".json";
    this.loadTailgateIntoFanzoneView( thePath );
  }
  
  this.cleanup = function()
  {
    this.myAbortFlag = true;
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
                                          hScroll: false,
                                          hScrollbar: false,
                                          onBeforeScrollStart: enableFormsOnBeforeScroll,
                                          onTouchEnd: scrollWindowToTopOnTouchEnd
                                        });
  }
  
  this.cleanupFanzoneScroller = function()
  {
    this.myFanzoneScroller.destroy()
    this.myFanzoneScroller = null;
  }
  

  this.onTailgateLoadComplete = function( aResult )
  {
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.myTailgateModel = aResult;
    
    $("#phoneFanzoneContent").show();
    $("#phoneFanzoneLoading").hide();

    this.renderBanner();
    this.renderFollowButton();  
    this.renderPostForm();
    this.setupFanzoneScroller();

    this.myFanzonePostsController.initialize(this.myTailgateModel.team.sport_id, this.myTailgateModel.topic_tags);

    updateTimestamps();
    this.onHomeClicked();
  };
  
  this.onLoadError = function(anError)
  {
    console.log(anError);  
  };
  
  this.updateScrollerAndScrollToTop = function()
  {
    this.myFanzoneScroller.refresh();
    this.myFanzoneScroller.scrollTo(0,0,0);
  }
  
  this.onHomeClicked = function(e)
  {
    this.myFanzoneHomeView.render(this.myTailgateModel, this.myFanzoneScroller);
    $("#posts").show();
    $("#tweetHolder").hide();
    $("#fanzoneMedia").hide();
    this.updateScrollerAndScrollToTop();
  }
  
  this.onSocialClicked = function(e)
  {
    this.myFanzoneSocialView.render(this.myTailgateModel, this.myFanzonePostsController, this.myFanzoneScroller);
    $("#posts").hide();
    $("#tweetHolder").show();
    $("#fanzoneMedia").hide();
    this.updateScrollerAndScrollToTop();
  }
  
  this.onMediaClicked = function(e)
  {
    this.myFanzoneMediaView.render(this.myTailgateModel);
    $("#posts").hide();
    $("#tweetHolder").hide();
    $("#fanzoneMedia").show();
    this.updateScrollerAndScrollToTop();
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
        var theTailgateFollower = theUserManager.getTailgateFollower( this.myTailgateModel.id );
        $("#followButton").render(theTailgateFollower, this.getUnfollowButtonDirective());
        $("#followButton form > div").append("<input id=\"method\" name=\"_method\" type=\"hidden\" value=\"delete\">");
        $("#followButton").show();
      }
      else
      {
        $("#followButton").render(this.myTailgateModel, this.getFollowButtonDirective());
        $("#followButton").find("#method").remove();
        $("#followButton").show();
      }
    }
    else
    {
      $("#followButton").hide();
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
  
  this.getFollowButtonDirective = function()
  {
    return {
      "form@action" : function() { return "/tailgate_followers"; },
      "form@class" : function() { return "new_tailgate_follower"; },
      "form@id" : function() { return "new_tailgate_follower"; },
      "input.follow_button@value" : function() { return "Follow"},
      "input.follow_button@id" : "id",
      "input#tailgate_follower_tailgate_id@value" : "id",
    }
  }
  
  this.getUnfollowButtonDirective = function()
  {
    return {
      "form@action" : function(anItem) { return "/tailgate_followers/" + anItem.context.id; },
      "form@class" : function() { return "edit_tailgate_follower"; },
      "form@id" : function() { return "edit_tailgate_follower"; },
      "input.follow_button@value" : function() { return "Unfollow"; },
      "input.follow_button@id" : function() { return ""; },
      "input#tailgate_follower_tailgate_id@value" : function() { return ""; },
    }
  }
  
}
