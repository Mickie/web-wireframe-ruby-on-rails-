describe Users::OmniauthCallbacksController do
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "getting twitter callbacks" do

    before do
      request.env["omniauth.auth"] = twitter_auth
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
        session["devise.twitter_data"].credentials.token.should  eq('a token')
        session["devise.twitter_data"].credentials.secret.should eq('a secret')
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
  
  
  describe "getting instagram callbacks" do

    before do
      request.env["omniauth.auth"] = instagram_auth
      request.env["devise.mapping"] = Devise.mappings[:user] 
    end
  
    describe "when no user signed in" do

      before do
        get :instagram 
      end

      it "should redirect to registration page" do
        response.should redirect_to(new_user_registration_path)
      end
      
      it "should have instagram data in session" do
        session["devise.instagram_data"].should_not be_nil
        session["devise.instagram_data"].credentials.token.should  eq('inst_token')
        session["devise.instagram_data"].info.name.should eq('Jim Bob')
        session["devise.instagram_data"].info.nickname eq('jimbob')
        session["devise.instagram_data"].uid eq('54321')
      end
    end
   
    describe "for existing user" do

      before do
        user.instagram_user_id = '54321'
        user.save
        get :instagram
      end      
      
      it "should find user and redirect to user profile" do
        response.should redirect_to( user_path(user) )
      end
      
    end
  end   
end