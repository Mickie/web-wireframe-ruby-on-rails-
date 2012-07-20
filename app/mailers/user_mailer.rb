class UserMailer < ActionMailer::Base
  add_template_helper( ApplicationHelper )

  default from: "notifications@fanzo.me", css: :email
  
  def new_fanzone_post( aPost )
    @post = aPost
    theSubject = "#{aPost.user.full_name} just posted on #{aPost.tailgate.name}"
    mail( to: "paulingalls@hotmail.com, paulingalls@gmail.com, paul_ingalls@yahoo.com", subject: theSubject )
#    mail( to: aPost.tailgate.user.email, subject: theSubject )
  end
end
