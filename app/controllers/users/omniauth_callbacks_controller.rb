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
                                                extra: { access_token: {  token: theAuthData.extra.access_token.token, 
                                                                          secret: theAuthData.extra.access_token.secret } } 
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
    end    
  end
end