class UserMailer < ActionMailer::Base
  add_template_helper( ApplicationHelper )

  default from: "Fanzo <notifications@fanzo.me>", css: :email
  
  def new_fanzone_post( aPost )
    @post = aPost

    theSubject = "#{aPost.user.full_name} just posted on #{aPost.tailgate.name}"
    theToAddress = "#{aPost.tailgate.user.full_name} <#{aPost.tailgate.user.email}>"
    attachments.inline['fanzo-logo.png'] = File.read(Rails.root.join("app", "assets", "images", "fanzo-logo.png"))
    mail( to: "paulingalls@hotmail.com, paulingalls@gmail.com, paul_ingalls@yahoo.com", subject: theSubject )
#    mail( to: theToAddress, subject: theSubject )
  end
  
  def new_post_comment( aComment )
    @comment = aComment

    theSubject = "#{aComment.user.full_name} just commented on your post in #{aComment.post.tailgate.name}"
    theToAddress = "#{aComment.post.user.full_name} <#{aComment.post.user.email}>"
    attachments.inline['fanzo-logo.png'] = File.read(Rails.root.join("app", "assets", "images", "fanzo-logo.png"))
    mail( to: "paulingalls@hotmail.com, paulingalls@gmail.com, paul_ingalls@yahoo.com", subject: theSubject )
#    mail( to: theToAddress, subject: theSubject )
  end
end
