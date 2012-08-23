class User < ActiveRecord::Base
  extend FriendlyId
  include Bitfields
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  friendly_id :full_name, use: :slugged

  has_many :user_teams, inverse_of: :user, dependent: :delete_all
  has_many :teams, through: :user_teams
  
  has_many :user_locations, inverse_of: :user, dependent: :destroy
  has_many :locations, through: :user_locations

  has_many :user_teams, inverse_of: :user, dependent: :delete_all
  has_many :teams, through: :user_teams
  
  has_many :i_was_there_brags, inverse_of: :user, dependent: :delete_all
  has_many :i_watched_brags, inverse_of: :user, dependent: :delete_all
  has_many :i_wish_brags, inverse_of: :user, dependent: :delete_all
  
  has_many :tailgates, inverse_of: :user, dependent: :destroy, order:"posts_updated_at DESC"
  
  has_many :tailgate_followers, inverse_of: :user, dependent: :delete_all
  has_many :followed_tailgates, through: :tailgate_followers, source: :tailgate, order:"posts_updated_at DESC" 
  
  has_many :posts, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy
  
  has_many :user_post_votes, inverse_of: :user, dependent: :delete_all
  has_many :user_comment_votes, inverse_of: :user, dependent: :delete_all

  bitfield :email_bit_flags, 1 => :no_email_on_posts, 
                             2 => :no_email_on_comments, 
                             4 => :no_email_newsletter, 
                             8 => :no_email_on_follows, 
                             16 => :no_email_summary_of_followed_tailgates,
                             32 => :no_fb_share_on_create_tailgate,
                             64 => :no_fb_share_on_follow_tailgate

  attr_accessible :email,
                  :first_name,
                  :last_name,
                  :image,
                  :description,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :twitter_user_id,
                  :twitter_username,
                  :twitter_user_token,
                  :twitter_user_secret,
                  :facebook_user_id,
                  :facebook_access_token,
                  :foursquare_user_id,
                  :foursquare_access_token,
                  :instagram_user_id,
                  :instagram_user_token,
                  :instagram_username,
                  :no_email_on_posts,
                  :no_email_on_comments,
                  :no_email_newsletter,
                  :no_email_on_follows,
                  :no_email_summary_of_followed_tailgates,
                  :no_fb_share_on_create_tailgate,
                  :no_fb_share_on_follow_tailgate
                  
  def isConnectedToTwitter?
    return twitter_user_token? && twitter_user_secret?
  end
  
  def followDefaultTailgate
    theDefaultTailgate = Tailgate.find_by_name("The World's Largest Tailgate Party!")
    if (theDefaultTailgate)
      follow!(theDefaultTailgate)
    end
  end
  
  def full_name
    if name && name.length > 0
      return name
    elsif ( first_name && first_name.length > 0 ) && ( last_name && last_name.length > 0)
      return "#{first_name} #{last_name}"
    elsif ( first_name && first_name.length > 0 ) && !( last_name && last_name.length > 0)
      return first_name
    elsif !( first_name && first_name.length > 0 ) && ( last_name && last_name.length > 0)
      return last_name
    elsif twitter_username && twitter_username.length > 0 
      return twitter_username
    elsif twitter_username && twitter_username.length > 0 
      return twitter_username
    elsif instagram_username && instagram_username.length > 0 
      return instagram_username
    else
      return email
    end 
  end
  
  def mine?( aTailgate )
    tailgates.include?( aTailgate )
  end
  
  def following?( aTailgate )
    aTailgate.followers.include?(self)
  end

  def mine_or_following?( aTailgate )
    mine?(aTailgate) || following?( aTailgate )
  end

  def follow!( aTailgate )
    tailgate_followers.create!( tailgate_id: aTailgate.id)
  end  

  def unfollow!( aTailgate )
    tailgate_followers.find_by_tailgate_id( aTailgate.id ).destroy
  end
  
  def myFanzones
    tailgates.all + followed_tailgates.all
  end
  
  def large_profile_pic( aWidth, aHeight )
    "https://graph.facebook.com/#{facebook_user_id}/picture?type=large&width=#{aWidth}&height=#{aHeight}"
  end
  
  def self.find_for_facebook_oauth(access_token, aSignedInUser=nil)
  
    theId = access_token.uid
    theToken = access_token.credentials.token
    theFirstName = access_token.info.first_name
    theLastName = access_token.info.last_name
    theEmail = access_token.info.email
    theImage = access_token.info.image
    theLocation = access_token.info.location
  
    theUserWithThisFacebookId = User.where( facebook_user_id: access_token.uid ).first
    
    if theUserWithThisFacebookId
      theUserWithThisFacebookId.facebook_access_token = theToken
      theUserWithThisFacebookId.save!
      return theUserWithThisFacebookId
    elsif aSignedInUser
      aSignedInUser.facebook_user_id = theId
      aSignedInUser.facebook_access_token = theToken
      aSignedInUser.first_name = theFirstName unless aSignedInUser.first_name
      aSignedInUser.last_name = theLastName unless aSignedInUser.last_name
      aSignedInUser.image = theImage unless aSignedInUser.image
      aSignedInUser.save!
      return aSignedInUser
    elsif theUserWithThisEmail = User.where( email: theEmail ).first
      theUserWithThisEmail.facebook_user_id = theId
      theUserWithThisEmail.facebook_access_token = theToken
      theUserWithThisEmail.first_name = theFirstName unless theUserWithThisEmail.first_name
      theUserWithThisEmail.last_name = theLastName unless theUserWithThisEmail.last_name
      theUserWithThisEmail.image = theImage unless theUserWithThisEmail.image
      theUserWithThisEmail.save!
      return theUserWithThisEmail
    else
      thePassword = Devise.friendly_token[0,20]
      theNewUser = User.create!( email: theEmail,
                                  password: thePassword,
                                  password_confirmation: thePassword,
                                  facebook_user_id: theId,
                                  facebook_access_token: theToken,
                                  first_name: theFirstName,
                                  last_name: theLastName,
                                  image: theImage,
                                  remember_me: true)
      theNewUser.followDefaultTailgate
      return theNewUser    
    end
  end
  
  def self.find_for_foursquare_oauth(access_token, aSignedInUser)

    theId = access_token.uid
    theToken = access_token.credentials.token
    theFirstName = access_token.info.first_name
    theLastName = access_token.info.last_name
    theEmail = access_token.info.email
    theImage = access_token.info.image
    theLocation = access_token.info.location

    theUserWithThisFoursquareId = User.where( foursquare_user_id: theId).first

    if theUserWithThisFoursquareId
      theUserWithThisFoursquareId.foursquare_access_token = theToken
      theUserWithThisFoursquareId.save!
      return theUserWithThisFoursquareId
    elsif aSignedInUser
      aSignedInUser.foursquare_user_id = theId
      aSignedInUser.foursquare_access_token = theToken
      aSignedInUser.first_name = theFirstName unless aSignedInUser.first_name
      aSignedInUser.last_name = theLastName unless aSignedInUser.last_name
      aSignedInUser.image = theImage unless aSignedInUser.image
      aSignedInUser.save!
      return aSignedInUser
    elsif theUserWithThisEmail = User.where( email: theEmail ).first
      theUserWithThisEmail.foursquare_user_id = theId
      theUserWithThisEmail.foursquare_access_token = theToken
      theUserWithThisEmail.first_name = theFirstName unless theUserWithThisEmail.first_name
      theUserWithThisEmail.last_name = theLastName unless theUserWithThisEmail.last_name
      theUserWithThisEmail.image = theImage unless theUserWithThisEmail.image
      theUserWithThisEmail.save!
      return theUserWithThisEmail
    else
      thePassword = Devise.friendly_token[0,20]
      theNewUser = User.create!( email: theEmail,
                                  password: thePassword,
                                  password_confirmation: thePassword,
                                  foursquare_user_id: theId,
                                  foursquare_access_token: theToken,
                                  first_name: theFirstName,
                                  last_name: theLastName,
                                  image: theImage,
                                  remember_me: true)
      theNewUser.followDefaultTailgate
      return theNewUser    
    end
  end
  

  def self.find_for_twitter_oauth(access_token, aSignedInUser)
  
    theId = access_token.uid
    theToken = access_token.credentials.token
    theSecret = access_token.credentials.secret
    theName = access_token.info.name
    theNickname = access_token.info.nickname
    theImage = access_token.info.image
    theBio = access_token.info.description
    theLocation = access_token.info.location
  
    theUserWithThisTwitterId = User.where( twitter_user_id: theId ).first

    if aSignedInUser
      if theUserWithThisTwitterId && aSignedInUser.id != theUserWithThisTwitterId.id
        theUserWithThisTwitterId.twitter_user_token = theToken
        theUserWithThisTwitterId.save!
        return theUserWithThisTwitterId
      elsif aSignedInUser.twitter_user_id
        aSignedInUser.twitter_user_token = theToken
        aSignedInUser.save!
        return aSignedInUser
      else
        aSignedInUser.twitter_user_id = theId
        aSignedInUser.twitter_username = theNickname
        aSignedInUser.twitter_user_token = theToken
        aSignedInUser.twitter_user_secret = theSecret
        aSignedInUser.name = theName unless aSignedInUser.name
        aSignedInUser.image = theImage unless aSignedInUser.image
        aSignedInUser.description = theBio unless aSignedInUser.description
        aSignedInUser.save!
        return aSignedInUser
      end
    else
      return theUserWithThisTwitterId
    end
  end

  def self.find_for_instagram_oauth(access_token, aSignedInUser)
    theId = access_token.uid
    theToken = access_token.credentials.token
    theName = access_token.info.name
    theNickname = access_token.info.nickname
    theImage = access_token.info.image
    theBio = access_token.info.bio

    theUserWithThisInstagramId = User.where( instagram_user_id: theId).first

    if aSignedInUser
      if aSignedInUser == theUserWithThisInstagramId
        aSignedInUser.instagram_user_token = theToken
        aSignedInUser.save!
        return aSignedInUser
      elsif theUserWithThisInstagramId
        theUserWithThisTwitterId.twitter_user_token = theToken
        theUserWithThisTwitterId.save!
        return theUserWithThisInstagramId
      else
        aSignedInUser.instagram_user_id = theId
        aSignedInUser.instagram_user_token = theToken
        aSignedInUser.instagram_username = theNickname
        aSignedInUser.name = theName unless aSignedInUser.name
        aSignedInUser.image = theImage unless aSignedInUser.image
        aSignedInUser.description = theBio unless aSignedInUser.description
        aSignedInUser.save!
        return aSignedInUser
      end
    else
      theUserWithThisInstagramId
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


