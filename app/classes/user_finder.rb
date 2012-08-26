class UserFinder

  def self.findOrCreateUserFromFacebookId(aFacebookId, aFacebookToken)
    
    theUser = User.find_by_facebook_user_id(aFacebookId)
    if theUser
      return theUser      
    else
      return UserFinder.createUserFromProfile( aFacebookId, aFacebookToken)
    end
  end 
  
  def self.createUserFromProfile( aFacebookId, aFacebookToken )
    theGraph = Koala::Facebook::API.new(aFacebookToken)
    
    begin
      theProfile = theGraph.get_object("me")
    rescue Exception => e
      Rails.logger.warn "Error getting info from facebook => #{e.to_s}"  
    end    

    thePassword = Devise.friendly_token[0,20]
    theImage = "http://graph.facebook.com/#{aFacebookId}/picture?type=square"
    theNewUser = User.create!( email: theProfile["email"],
                                password: thePassword,
                                password_confirmation: thePassword,
                                facebook_user_id: aFacebookId,
                                facebook_access_token: aFacebookToken,
                                first_name: theProfile["first_name"],
                                last_name: theProfile["last_name"],
                                image: theImage,
                                remember_me: true)
    theNewUser.name = theProfile["name"]                                
    theNewUser.followDefaultTailgate
    
    return theNewUser
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

  
end
