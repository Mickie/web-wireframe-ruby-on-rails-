class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end 
  
  def twitter
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

    if @user
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @user, event: :authentication
    else
      theAuthData = request.env["omniauth.auth"]
      theTwitterData = OmniAuth::AuthHash.new({ uid: theAuthData.uid, 
                                                info: { nickname: theAuthData.info.nickname }, 
                                                credentials: {  token: theAuthData.credentials.token, 
                                                                secret: theAuthData.credentials.secret }  
                                              })
      session["devise.twitter_data"] = theTwitterData
      redirect_to new_user_registration_url
    end
  end 
  
  def instagram
    @user = User.find_for_instagram_oauth(request.env["omniauth.auth"], current_user)

    if @user
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Instagram"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.instagram_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end    
  end

  def foursquare
    @user = User.find_for_foursquare_oauth(request.env["omniauth.auth"], current_user)

    if @user
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Foursquare"
      sign_in_and_redirect @user, event: :authentication
    else
      theAuthData = request.env["omniauth.auth"]
      theFoursquareData = OmniAuth::AuthHash.new({ uid: theAuthData.uid, 
                                                   credentials: { token: theAuthData.credentials.token } 
                                                  })
      session["devise.foursquare_data"] = theFoursquareData
      redirect_to new_user_registration_url
    end    
  end

end