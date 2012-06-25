class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :user_teams, inverse_of: :user, dependent: :delete_all
  has_many :teams, through: :user_teams
  
  has_many :user_locations, inverse_of: :user, dependent: :destroy
  has_many :locations, through: :user_locations
  
  has_many :tailgates, inverse_of: :user, dependent: :destroy
  
  has_many :tailgate_followers, inverse_of: :user, dependent: :delete_all
  has_many :followed_tailgates, through: :tailgate_followers, source: :tailgate 

  attr_accessible :email,
                  :first_name,
                  :last_name,
                  :image,
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
                  :instagram_username
                  
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
      return theUserWithThisFacebookId
    elsif aSignedInUser
      aSignedInUser.facebook_user_id = theId
      aSignedInUser.facebook_access_token = theToken
      aSignedInUser.first_name = theFirstName unless aSignedInUser.first_name
      aSignedInUser.last_name = theLastName unless aSignedInUser.last_name
      aSignedInUser.image = theImage unless aSignedInUser.image
      aSignedInUser.remember_me = true
      aSignedInUser.save!
      return aSignedInUser
    elsif theUserWithThisEmail = User.where( email: theEmail ).first
      theUserWithThisEmail.facebook_user_id = theId
      theUserWithThisEmail.facebook_access_token = theToken
      theUserWithThisEmail.first_name = theFirstName unless theUserWithThisEmail.first_name
      theUserWithThisEmail.last_name = theLastName unless theUserWithThisEmail.last_name
      theUserWithThisEmail.image = theImage unless theUserWithThisEmail.image
      theUserWithThisEmail.remember_me = true
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
      return theUserWithThisFoursquareId
    elsif aSignedInUser
      aSignedInUser.foursquare_user_id = theId
      aSignedInUser.foursquare_access_token = theToken
      aSignedInUser.first_name = theFirstName unless aSignedInUser.first_name
      aSignedInUser.last_name = theLastName unless aSignedInUser.last_name
      aSignedInUser.image = theImage unless aSignedInUser.image
      aSignedInUser.remember_me = true
      aSignedInUser.save!
      return aSignedInUser
    elsif theUserWithThisEmail = User.where( email: theEmail ).first
      theUserWithThisEmail.foursquare_user_id = theId
      theUserWithThisEmail.foursquare_access_token = theToken
      theUserWithThisEmail.first_name = theFirstName unless theUserWithThisEmail.first_name
      theUserWithThisEmail.last_name = theLastName unless theUserWithThisEmail.last_name
      theUserWithThisEmail.image = theImage unless theUserWithThisEmail.image
      theUserWithThisEmail.remember_me = true
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
        return theUserWithThisTwitterId
      elsif aSignedInUser.twitter_user_id
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
        return aSignedInUser
      elsif theUserWithThisInstagramId
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

  def isConnectedToTwitter?
    return twitter_user_token? && twitter_user_secret?
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
  
  def following?( aTailgate )
    tailgate_followers.find_by_tailgate_id( aTailgate.id )
  end

  def follow!( aTailgate )
    tailgate_followers.create!( tailgate_id: aTailgate.id)
  end  

  def unfollow!( aTailgate )
    tailgate_followers.find_by_tailgate_id( aTailgate.id ).destroy
  end
end


