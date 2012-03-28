class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  validates_uniqueness_of :email

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, 
                  :email, 
                  :password, 
                  :password_confirmation, 
                  :remember_me, 
                  :twitter_user_id, 
                  :twitter_username, 
                  :twitter_user_token, 
                  :twitter_user_secret,
                  :facebook_user_id,
                  :facebook_access_token
  
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = User.where( facebook_user_id: access_token.uid ).first
      user
    elsif user = User.where( email: data.email ).first
      user
    else 
      User.create!( email: data.email, 
                    password: Devise.friendly_token[0,20], 
                    facebook_user_id: access_token.uid, 
                    facebook_access_token: access_token.credentials.token) 
    end
  end
  
  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    if user = User.where( twitter_user_id: access_token.uid).first
      user
    else 
      User.create!( email: 'twitter_init@fanzo.co', 
                    password: Devise.friendly_token[0,20],
                    twitter_user_id: access_token.uid, 
                    twitter_username: access_token.info.nickname, 
                    twitter_user_token: access_token.extra.access_token.token,
                    twitter_user_secret: access_token.extra.access_token.secret) 
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
  
end
