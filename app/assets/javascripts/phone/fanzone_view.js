var FanzoneView = function()
{
  this.myTailgateModel = {};
  
  this.loadTailgate = function( aPath )
  {
    var thePath = aPath + ".json";
    this.clearContents();
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

  this.clearContents = function()
  {
    $("#phoneFanzoneContent #posts").empty();
  }

  this.onTailgateLoadComplete = function( aResult )
  {
    this.myTailgateModel = aResult;
    
    $("#phoneFanzoneContent").show();
    $("#phoneFanzoneLoading").hide();

    this.renderBanner();    
    this.renderPostForm();    
    updateTimestamps();
    
    setTimeout(createDelegate(this, this.renderPosts), 10);
  };
  
  this.renderBanner = function()
  {
    $("#phoneFanzoneBanner").render(this.myTailgateModel, this.getFanzoneDirective());
  }
  
  this.renderPostForm = function()
  {
    $("#postForm").render(this.myTailgateModel, this.getPostFormDirective());
  }
  
  this.renderPosts = function()
  {
    for(var i=0,j=this.myTailgateModel.posts.length; i<j; i++)
    {
      $("#posts").append(this.generatePostDiv(this.myTailgateModel.posts[i]));
    }
    updateTimestamps();
  }
  
  this.renderPostMediaIntoDiv = function( aPost, aDiv )
  {
    if (aPost.image_url && aPost.image_url.length > 0)
    {
      if (aPost.video_id && aPost.video_id.length > 0)
      {
        var theVideoDiv = $("#postVideoTemplate .post_video").clone().render(aPost, this.getPostVideoDirective());
        aDiv.find(".post_media").append(theVideoDiv);
      }
      else
      {
        var theImageDiv = $("#postImageTemplate .post_image").clone().render(aPost, this.getPostImageDirective());
        aDiv.find(".post_media").append(theImageDiv);
      }
    }
  }

  this.renderCommentIntoDiv = function( aComment, aPost, aDiv )
  {
    var theCommentDiv = $("#postCommentTemplate .comment").clone().render(aComment, this.getPostCommentDirective(aPost));
    aDiv.find(".post_comments").append(theCommentDiv);
  }
  
  this.renderCommentsFormIntoDiv = function( aPost, aDiv )
  {
    var theCommentFormDiv = $("#postCommentFormTemplate .post_comment_form").clone().render(aPost, this.getPostCommentFormDirective());
    aDiv.append(theCommentFormDiv);
  }
  
  this.renderCommentsIntoDiv = function( aPost, aDiv )
  {
    for (var i=0; i < aPost.comments.length; i++) 
    {
      this.renderCommentIntoDiv( aPost.comments[i], aPost, aDiv )
    };
    this.renderCommentsFormIntoDiv( aPost, aDiv );
  }

  this.generatePostDiv = function( aPost )
  {
    try
    {
      var theDiv = $("#postTemplate").clone().render(aPost, this.getPostDirective());
      this.renderPostMediaIntoDiv(aPost, theDiv);
      this.renderCommentsIntoDiv(aPost, theDiv);
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
      }
    }
  };
  
  this.getPostFormDirective = function()
  {
    return {
      "#postForm .profile_pic": function(anItem)
      {
        return "<img src='" + myPhoneNavigator.myFacebookController.myModel.getProfilePicUrl() + "' width='24' height='24' />";
      },
      "#new_post@action" : function(anItem)
      {
        return "/tailgates/" + anItem.context.slug + "/posts";
      }      
    }
  }
  
  this.getPostDirective = function()
  {
    var theThis = this;
    return {
      ".fan_score" : "fan_score",
      ".timestamp@title" : "created_at",
      ".timestamp" : "created_at",
      ".@class" : function(){ return "post"; },
      ".@id" : function(anItem)
      {
        return "post_" + anItem.context.id;
      },
      ".post_comments@id" : function(anItem)
      {
        return "post_" + anItem.context.id + "_comments";
      },
      ".user_name" : function(anItem)
      {
        return anItem.context.user.first_name + " " + anItem.context.user.last_name;
      },
      "p": "content",
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
    }
  }  

  this.getPostCommentDirective = function( aPost )
  {
    return {
      ".fan_score" : "fan_score",
      ".timestamp@title" : "created_at",
      ".timestamp" : "created_at",
      ".@id" : function(anItem)
      {
        return "post_" + aPost.id + "_comment_" + anItem.context.id;
      },
      ".user_name" : function(anItem)
      {
        return anItem.context.user.first_name + " " + anItem.context.user.last_name;
      },
      "p": "content",
      ".vote_up form.edit_comment@action": function(anItem)
      {
        return "/tailgates/" + aPost.tailgate_id + "/posts/" + aPost.id + "/comments/" + anItem.context.id + "/up_vote";
      },
      ".vote_down form.edit_comment@action": function(anItem)
      {
        return "/tailgates/" + aPost.tailgate_id + "/posts/" + aPost.id + "/comments/" + anItem.context.id + "/down_vote";
      },
      ".profile_pic": function(anItem)
      {
        return "<img src='" + anItem.context.user.image + "' width='24' height='24' />";
      },
    }
  }
  
  this.getPostCommentFormDirective = function()
  {
    return {
      "form@action" : function(anItem)
      {
        return "/tailgates/" + anItem.context.tailgate_id + "/posts/" + anItem.context.id + "/comments";
      },
      ".profile_pic" : function(anItem)
      {
        return "<img src='" + myPhoneNavigator.myFacebookController.myModel.getProfilePicUrl() + "' width='24' height='24' />";
      }
    }
  }

  this.getPostVideoDirective = function()
  {
    return {
      ".@id": "video_id",
      "img@src": "image_url"
    };
  }  

  this.getPostImageDirective = function()
  {
    return {
      "img@src": "image_url"
    };
  }
  
}
