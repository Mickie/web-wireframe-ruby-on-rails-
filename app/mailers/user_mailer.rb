class UserMailer < ActionMailer::Base
  add_template_helper( ApplicationHelper )

  default from: "Fanzo <notifications@fanzo.me>", css: :email
  
  def new_fanzone_post( aPostId )
    @post = Post.includes(:user, :tailgate => :user).find_by_id(aPostId)

    if @post
      theSubject = "#{@post.user.full_name} just posted on #{@post.tailgate.name}"
      theToAddress = "#{@post.tailgate.user.full_name} <#{@post.tailgate.user.email}>"
      createMail( theToAddress, theSubject )
    else
      Rails.logger.warn "Error sending new_fanzone_post email, post not found"
    end
  end
  
  def new_post_comment( aCommentId )
    @comment = Comment.includes(:user, :post => [:user, :tailgate => :user]  ).find_by_id(aCommentId)

    if @comment
      theSubject = "#{@comment.user.full_name} just commented on your post in #{@comment.post.tailgate.name}"
      theToAddress = "#{@comment.post.user.full_name} <#{@comment.post.user.email}>"
      createMail( theToAddress, theSubject )
    else
      Rails.logger.warn "Error sending new_post_comment email, comment not found"
    end
  end
  
  def also_commented( aCommentId, aUserId )
    @comment = Comment.includes(:user, :post => [:user, :tailgate => :user]  ).find_by_id(aCommentId)
    @user = User.find_by_id(aUserId)

    if @comment
      theSubject = "#{@comment.user.full_name} also commented on a post in #{@comment.post.tailgate.name}"
      theToAddress = "#{@user.full_name} <#{@user.email}>"
      createMail( theToAddress, theSubject )
    else
      Rails.logger.warn "Error sending also_post_comment email, comment not found"
    end
  end
  
  def new_follower( aTailgateFollowerId )
    @tailgateFollower = TailgateFollower.includes(:user, :tailgate => :user).find_by_id(aTailgateFollowerId)
    
    if @tailgateFollower
      theSubject = "Your #{@tailgateFollower.tailgate.name} fanzone has a new follower"
      theToAddress = "#{@tailgateFollower.tailgate.user.full_name} <#{@tailgateFollower.tailgate.user.email}>"
      createMail( theToAddress, theSubject )
    else
      Rails.logger.warn "Error sending new_follower email, tailgateFollower not found"
    end
  end
  
  def updates_on_followed_fanzones( aUser, aTailgateDetailsMap )
    @user = aUser
    @tailgateDetailsMap = aTailgateDetailsMap

    theSubject = "Your Fanzo activity report"
    theToAddress = "#{@user.full_name} <#{@user.email}>"
    createMail( theToAddress, theSubject )
  end
  
  private
  
  def createMail( aToAddress, aSubject )
    @fanzo_fact = FunFact.limit(1).offset(rand(FunFact.count)).first
    @fanzo_tip = FanzoTip.limit(1).offset(rand(FanzoTip.count)).first
    attachments.inline['fanzo-logo.png'] = File.read(Rails.root.join("app", "assets", "images", "fanzo-logo.png"))
    if Rails.env.development?
      mail( to: "paulingalls@hotmail.com, paulingalls@gmail.com, paul_ingalls@yahoo.com", subject: aSubject )
    else
      mail( to: aToAddress, subject: aSubject )
    end
  end
end
