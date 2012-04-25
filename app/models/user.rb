class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  has_many :user_teams
  has_many :teams, through: :user_teams
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, 
                  :password, 
                  :password_confirmation, 
                  :remember_me, 
                  :twitter_user_id, 
                  :twitter_username, 
                  :twitter_user_token, 
                  :twitter_user_secret,
                  :facebook_user_id,
                  :facebook_access_token,
                  :user_teams,
                  :teams
  
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    if user = User.where( facebook_user_id: access_token.uid ).first
      user
    elsif user = User.where( email: access_token.info.email ).first
      user
    else 
      thePassword = Devise.friendly_token[0,20]
      User.create!( email: access_token.info.email, 
                    password: thePassword, 
                    password_confirmation: thePassword,
                    facebook_user_id: access_token.uid, 
                    facebook_access_token: access_token.credentials.token) 
    end
  end
  
  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    User.where( "twitter_user_id = ?", access_token.uid).first
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
  
end
