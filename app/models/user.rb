class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :user_teams, inverse_of: :user, dependent: :delete_all
  has_many :teams, through: :user_teams
  
  has_many :user_locations, inverse_of: :user, dependent: :delete_all
  has_many :locations, through: :user_locations
  
  has_many :tailgates, inverse_of: :user, dependent: :delete_all

  # Setup accessible (or protected) attributes for your model
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
                  :instagram_username,
                  :user_teams,
                  :teams,
                  :user_locations,
                  :locations,
                  :tailgates 
                  
  def self.find_for_facebook_oauth(access_token, signed_in_user=nil)
  
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
    elsif signed_in_user
      signed_in_user.facebook_user_id = theId
      signed_in_user.facebook_access_token = theToken
      signed_in_user.first_name = theFirstName unless signed_in_user.first_name
      signed_in_user.last_name = theLastName unless signed_in_user.last_name
      signed_in_user.image = theImage unless signed_in_user.image
      signed_in_user.save!
      return signed_in_user
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
                                  image: theImage)
      return theNewUser    
    end
  end
  
  def self.find_for_foursquare_oauth(access_token, signed_in_user)

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
    elsif signed_in_user
      signed_in_user.foursquare_user_id = theId
      signed_in_user.foursquare_access_token = theToken
      signed_in_user.first_name = theFirstName unless signed_in_user.first_name
      signed_in_user.last_name = theLastName unless signed_in_user.last_name
      signed_in_user.image = theImage unless signed_in_user.image
      signed_in_user.save!
      return signed_in_user
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
                                  image: theImage)
      return theNewUser    
    end
  end
  

  def self.find_for_twitter_oauth(access_token, signed_in_user)
  
    theId = access_token.uid
    theToken = access_token.credentials.token
    theSecret = access_token.credentials.secret
    theName = access_token.info.name
    theNickname = access_token.info.nickname
    theImage = access_token.info.image
    theBio = access_token.info.description
    theLocation = access_token.info.location
  
    theUserWithThisTwitterId = User.where( twitter_user_id: theId ).first

    if signed_in_user
      if theUserWithThisTwitterId && signed_in_user.id != theUserWithThisTwitterId.id
        return theUserWithThisTwitterId
      elsif signed_in_user.twitter_user_id
        return signed_in_user
      else
        signed_in_user.twitter_user_id = theId
        signed_in_user.twitter_username = theNickname
        signed_in_user.twitter_user_token = theToken
        signed_in_user.twitter_user_secret = theSecret
        signed_in_user.name = theName unless signed_in_user.name
        signed_in_user.image = theImage unless signed_in_user.image
        signed_in_user.description = theBio unless signed_in_user.description
        signed_in_user.save!
        return signed_in_user
      end
    else
      return theUserWithThisTwitterId
    end
  end

  def self.find_for_instagram_oauth(access_token, signed_in_user)
    theId = access_token.uid
    theToken = access_token.credentials.token
    theName = access_token.info.name
    theNickname = access_token.info.nickname
    theImage = access_token.info.image
    theBio = access_token.info.bio

    theUserWithThisInstagramId = User.where( instagram_user_id: theId).first

    if signed_in_user
      if signed_in_user == theUserWithThisInstagramId
        return signed_in_user
      elsif theUserWithThisInstagramId
        return theUserWithThisInstagramId
      else
        signed_in_user.instagram_user_id = theId
        signed_in_user.instagram_user_token = theToken
        signed_in_user.instagram_username = theNickname
        signed_in_user.name = theName unless signed_in_user.name
        signed_in_user.image = theImage unless signed_in_user.image
        signed_in_user.description = theBio unless signed_in_user.description
        signed_in_user.save!
        return signed_in_user
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

end


