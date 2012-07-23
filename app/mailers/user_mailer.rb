class UserMailer < ActionMailer::Base
  add_template_helper( ApplicationHelper )

  default from: "Fanzo <notifications@fanzo.me>", css: :email
  
  def new_fanzone_post( aPostId )
    @post = Post.includes(:user, :tailgate => :user).find_by_id(aPostId)

    theSubject = "#{@post.user.full_name} just posted on #{@post.tailgate.name}"
    theToAddress = "#{@post.tailgate.user.full_name} <#{@post.tailgate.user.email}>"
    attachments.inline['fanzo-logo.png'] = File.read(Rails.root.join("app", "assets", "images", "fanzo-logo.png"))
    mail( to: "paulingalls@hotmail.com, paulingalls@gmail.com, paul_ingalls@yahoo.com", subject: theSubject )
#    mail( to: theToAddress, subject: theSubject )
  end
  
  def new_post_comment( aCommentId )
    @comment = Comment.includes(:user, :post => [:user, :tailgate => :user]  ).find_by_id(aCommentId)

    theSubject = "#{@comment.user.full_name} just commented on your post in #{@comment.post.tailgate.name}"
    theToAddress = "#{@comment.post.user.full_name} <#{@comment.post.user.email}>"
    attachments.inline['fanzo-logo.png'] = File.read(Rails.root.join("app", "assets", "images", "fanzo-logo.png"))
    mail( to: "paulingalls@hotmail.com, paulingalls@gmail.com, paul_ingalls@yahoo.com", subject: theSubject )
#    mail( to: theToAddress, subject: theSubject )
  end
end
