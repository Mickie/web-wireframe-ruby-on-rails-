var FanzoneHomeView = function()
{
  this.myTailgateModel = null;
  this.myCurrentPage = 1;
  this.myAbortFlag = false;
  this.myPostsScroller = null;
  EventManager.get().addObserver("onCreatePostComplete", this);
  
  this.render = function( aTailgateModel )
  {
    if (this.myTailgateModel && this.myTailgateModel.id == aTailgateModel.id)
    {
      return;
    }
    
    this.myAbortFlag = false;
    this.myCurrentPage = 1;
    this.myTailgateModel = aTailgateModel;
    
    this.loadPosts();
  }
  
  this.cleanup = function()
  {
    this.myAbortFlag = true;
    this.myTailgateModel = null;
    this.cleanupPostsScroller();
    $("#phoneFanzoneContent #posts").empty();
  }
  
  this.onCreatePostComplete = function()
  {
    this.myPostsScroller.refresh();
  }

  this.loadPosts = function()
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    var thePath = "/tailgates/" + this.myTailgateModel.slug + "/posts?authenticity_token=" + theToken + "&page=" + this.myCurrentPage
    $.ajax({
             url: thePath,
             cache:false,
             dataType: "json",
             success: createDelegate(this, this.onPostsLoadComplete ),
             error: createDelegate(this, this.onLoadError )
           });
  }
  
  this.onPostsLoadComplete = function(aResult)
  {
    if (this.myAbortFlag)
    {
      return;
    }
    this.renderPosts(aResult);
    
    setTimeout(createDelegate(this, this.setupPostsScroller), 200);
  }
  
  this.setupPostsScroller = function()
  {
    this.myPostsScroller = new iScroll("postsScroller",
                                        {
                                          hScroll: false,
                                          hScrollbar: false,
                                          onBeforeScrollStart: enableFormsOnBeforeScroll,
                                          onTouchEnd: scrollWindowToTopOnTouchEnd
                                        });
    $("#postsAndComments").on("touchmove", "#postsScroller", function (e) { e.preventDefault(); });
  }
  
  this.cleanupPostsScroller = function()
  {
    $("#postsAndComments").off("touchmove", "#postsScroller");
    if (this.myPostsScroller)
    {
      this.myPostsScroller.destroy()
      this.myPostsScroller = null;
    }
  }
  
  this.renderPosts = function( aListOfPosts )
  {
    var theParentDiv = $("#posts");
    for(var i=0,j=aListOfPosts.length; i<j; i++)
    {
      this.renderPost(aListOfPosts[i], theParentDiv);
    }
    updateTimestamps();
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
  
  this.renderPostMediaIntoDiv = function( aPost, aDiv )
  {
    if ( aPost.photo_url && aPost.photo_url.length > 0 )
    {
      var theImageDiv = $("#postImageTemplate .post_image").clone().render(aPost, this.getPostImageDirective());
      aDiv.find(".post_media").append(theImageDiv);
    }
    else if ( aPost.image_url && aPost.image_url.length > 0 )
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
        if (UserManager.get().isLoggedIn())
        {
          return "<img src='" + UserManager.get().getProfilePicUrl() + "' width='24' height='24' />";
        }
        return "";
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
      "img@src": function(anItem)
      {
        return anItem.context.photo_url || anItem.context.image_url;
      }
    };
  }
}
