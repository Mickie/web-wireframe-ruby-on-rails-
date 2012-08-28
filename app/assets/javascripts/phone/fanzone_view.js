var FanzoneView = function()
{
  this.myTailgateModel = {};
  
  this.loadTailgate = function( aPath )
  {
    var thePath = aPath + ".json";
    this.loadTailgateIntoFanzoneView( thePath );
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
    console.log(this.myTailgateModel);
    
    $("#phoneFanzoneContent").show();
    $("#phoneFanzoneLoading").hide();

    $("#phoneFanzoneContent").render(this.myTailgateModel, this.getFanzoneDirective());
    updateTimestamps();
    
    
    //setTimeout(createDelegate(this, this.renderPosts), 10);
  };
  
  this.renderPosts = function()
  {
    console.log(this.myTailgateModel.posts[0]);
    return;
    
    for(var i=0,j=this.myTailgateModel.posts.length; i<j; i++)
    {
      $("#posts").append(this.generatePostDiv(this.myTailgateModel.posts[i]));
    }
    
  }

  this.generatePostDiv = function( aPost )
  {
    try
    {
      var theDiv = $("#postTemplate").clone().render(aPost, this.getPostDirective());
      return theDiv;
    }
    catch(anError)
    {
      console.log(anError);
      return "<div></div>";    
    }
  }

  this.onLoadError = function(anError)
  {
    console.log(anError);  
  };
  
  this.getFanzoneDirective = function()
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
      },
      "#postForm .profile_pic": function(anItem)
      {
        return "<img src='" + myPhoneNavigator.myFacebookController.myModel.getProfilePicUrl() + "' width='24' height='24' />";
      },
      "#new_post@action" : function(anItem)
      {
        return "/tailgates/" + anItem.context.slug + "/posts";
      }
    }
  };
  
  this.getFanzoneDirective = function()
  {
    var theThis = this;
    return {
      ".@class" : function() { return "" },
      ".fan_score" : "fan_score",
      ".timestamp@title" : "created_at",
      ".timestamp" : "created_at",
      ".vote_up form.edit_post@action": function(anItem)
      {
        return "/tailgates/" + anItem.context.tailgate_id + "/posts/" + anItem.context.id + "/up_vote";
      },
      ".vote_down form.edit_post@action": function(anItem)
      {
        return "/tailgates/" + anItem.context.tailgate_id + "/posts/" + anItem.context.id + "/down_vote";
      },
      ".profile_pic": function(anItem)
      {
        return "<img src='" + anItem.context.user.image + "' width='24' height='24' />";
      },
      ".post_media": function(anItem)
      {
        return theThis.getMediaHtml(anItem.context);
      }
    }
  }  
  
  this.getMediaHtml = function(aPost)
  {
    if (aPost.image_url && aPost.image_url.length > 0)
    {
      if (aPost.video_id && aPost.video_id.length > 0)
      {
      }
      else
      {
      }
      
    }
  }
}
