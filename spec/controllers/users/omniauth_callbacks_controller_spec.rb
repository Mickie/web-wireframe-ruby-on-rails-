describe Users::OmniauthCallbacksController do
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "getting twitter callbacks" do

    before do
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
                                              { uid: '12345', 
                                              info: { nickname: "barney" }, 
                                              extra: { access_token: { token: "a token", secret: "a secret"} } 
                                              })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      request.env["devise.mapping"] = Devise.mappings[:user] 
    end
  
    describe "when no user signed in" do

      before do
        get :twitter 
      end

      it "should redirect to registration page" do
        response.should redirect_to(new_user_registration_path)
      end
      
      it "should have twitter data in session" do
        session["devise.twitter_data"].should_not be_nil
        session["devise.twitter_data"].extra.access_token.token.should  eq('a token')
        session["devise.twitter_data"].extra.access_token.secret.should eq('a secret')
        session["devise.twitter_data"].info.nickname eq('barney')
        session["devise.twitter_data"].uid eq('12345')
      end
    end
   
    describe "for existing user" do

      before do
        user.twitter_user_id = '12345'
        user.save
        get :twitter
      end      
      
      it "should find user and redirect to user profile" do
        response.should redirect_to( user_path(user) )
      end
      
    end
  end  
end