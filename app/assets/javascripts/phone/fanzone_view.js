var FanzoneView = function()
{
  this.myTailgateModel = {};
  this.myFanzonePostView = FanzonePostView.create("#postsAndComments");
  this.myFanzoneScroller = null;
  
  this.initialize = function()
  {
  }
  
  this.loadTailgate = function( aPath )
  {
    var thePath = aPath + ".json";
    this.setupFanzoneScroller();
    this.loadTailgateIntoFanzoneView( thePath );
  }
  
  this.cleanup = function()
  {
    this.clearContents();
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
    this.renderFollowButton();  
    this.renderPostForm();
    updateTimestamps();
    
    this.myFanzonePostView.initialize(this.myTailgateModel.team.sport_id, this.myTailgateModel.topic_tags);
    
    setTimeout(createDelegate(this, this.renderPosts), 10);
  };
  
  this.renderBanner = function()
  {
    $("#phoneFanzoneBanner").render(this.myTailgateModel, this.getFanzoneDirective());
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
  
  this.renderPost = function(aPost, aParentDiv)
  {
    var theUserId = UserManager.get().getUserId();
    var theUsersPost = false;
    var theUsersUpVote = false;
    var theUsersDownVote = false;
    
    if (theUserId)
    {
      theUsersPost = theUserId == aPost.user_id;
      
      var theVote = UserManager.get().getPostVote(aPost.id);
      theUsersUpVote = theVote && theVote.up_vote;
      theUsersDownVote = theVote && !theVote.up_vote;
    }

    aParentDiv.append(this.generatePostDiv(aPost, theUsersPost, theUsersUpVote, theUsersDownVote));
  }
  
  this.renderPosts = function()
  {
    var theParentDiv = $("#posts");
    for(var i=0,j=this.myTailgateModel.posts.length; i<j; i++)
    {
      this.renderPost(this.myTailgateModel.posts[i], theParentDiv);
    }
    updateTimestamps();
    this.myFanzoneScroller.refresh();
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
    var theUserId = UserManager.get().getUserId();
    var theUsersComment = false;
    var theUsersUpVote = false;
    var theUsersDownVote = false;
    
    if (theUserId)
    {
      theUsersComment = theUserId == aComment.user_id;
      
      var theVote = UserManager.get().getCommentVote(aComment.id);
      theUsersUpVote = theVote && theVote.up_vote;
      theUsersDownVote = theVote && !theVote.up_vote;
    }
    
    var theCommentDiv = $("#postCommentTemplate .comment").clone();
    theCommentDiv = theCommentDiv.render(aComment, this.getPostCommentDirective(aPost, theUsersComment, theUsersUpVote, theUsersDownVote));
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

  this.generatePostDiv = function( aPost, aUsersPost, aUsersUpVote, aUsersDownVote )
  {
    try
    {
      var theDiv = $("#postTemplate").clone().render(aPost, this.getPostDirective( aUsersPost, aUsersUpVote, aUsersDownVote ));
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
  
  this.onFollow = function(e)
  {
    alert("follow")
  }
  
  this.onUnfollow = function(e)
  {
    alert("unfollow")
  }
  
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
        return "<img src='" + UserManager.get().getProfilePicUrl() + "' width='24' height='24' />";
      },
      "#new_post@action" : function(anItem)
      {
        return "/tailgates/" + anItem.context.slug + "/posts";
      }      
    }
  }
  
  this.getPostDirective = function( aUsersPost, aUsersUpVote, aUsersDownVote )
  {
    var theDirective = {
      ".fan_score" : "fan_score",
      ".timestamp@title" : "created_at",
      ".timestamp" : "created_at",
      "p": "content",
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
      ".profile_pic": function(anItem)
      {
        return "<img src='" + anItem.context.user.image + "' width='24' height='24' />";
      }
    };
    
    if (aUsersUpVote)
    {
      theDirective[".vote_up"] = function()
      {
        return "<i class=\"icon-thumbs-up icon-white disabled\"></i>";
      }
    }
    else
    {
      theDirective[".vote_up form.edit_post@action"] = function(anItem)
      {
        return "/tailgates/" + anItem.context.tailgate_id + "/posts/" + anItem.context.id + "/up_vote";
      } 
    }
    
    if (aUsersPost)
    {
      theDirective[".vote_down"] = function( anItem )
      {
         return "<a href=\"/tailgates/" + anItem.context.tailgate_id + "/posts/" + anItem.context.id + "\""
                  + " data-confirm=\"Delete your post?\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\">"
                  + "<i class=\"icon-remove mine\"></i></a>"
      }
    }
    else if (aUsersDownVote)
    {
      theDirective[".@style"] = function() { return "display:none;" };
    }
    else
    {
      theDirective[".vote_down form.edit_post@action"] = function(anItem)
      {
        return "/tailgates/" + anItem.context.tailgate_id + "/posts/" + anItem.context.id + "/down_vote";
      }
    }
        
    return theDirective;
  }  

  this.getPostCommentDirective = function( aPost, aUsersComment, aUsersUpVote, aUsersDownVote )
  {
    var theDirective =
    {
      ".fan_score" : "fan_score",
      ".timestamp@title" : "created_at",
      ".timestamp" : "created_at",
      "p": "content",
      ".@id" : function(anItem)
      {
        return "post_" + aPost.id + "_comment_" + anItem.context.id;
      },
      ".user_name" : function(anItem)
      {
        return anItem.context.user.first_name + " " + anItem.context.user.last_name;
      },
      ".profile_pic": function(anItem)
      {
        return "<img src='" + anItem.context.user.image + "' width='24' height='24' />";
      }
    };
    
    if (aUsersUpVote)
    {
      theDirective[".vote_up"] = function()
      {
        return "<i class=\"icon-thumbs-up icon-white disabled\"></i>";
      }
    }
    else
    {
      theDirective[".vote_up form.edit_comment@action"] = function(anItem)
      {
        return "/tailgates/" + aPost.tailgate_id + "/posts/" + aPost.id + "/comments/" + anItem.context.id + "/up_vote";
      } 
    }
    
    if (aUsersComment)
    {
      theDirective[".vote_down"] = function( anItem )
      {
         return "<a href=\"/tailgates/" + aPost.tailgate_id + "/posts/" + aPost.id + "/comments/" + anItem.context.id + "\""
                  + " data-confirm=\"Delete your comment?\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\">"
                  + "<i class=\"icon-remove mine\"></i></a>"
      }
    }
    else if (aUsersDownVote)
    {
      theDirective[".@style"] = function() { return "display:none;" };
    }
    else
    {
      theDirective[".vote_down form.edit_comment@action"] = function(anItem)
      {
        return "/tailgates/" + aPost.tailgate_id + "/posts/" + aPost.id + "/comments/" + anItem.context.id + "/down_vote";
      }
    }
    
    return theDirective;
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
        return "<img src='" + UserManager.get().getProfilePicUrl() + "' width='24' height='24' />";
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
