require_relative '../spec_helper'

describe User do
  
  before do
    @user = FactoryGirl.create(:user)
  end
  
  subject { @user }
  
  it { should respond_to(:email) }
  it { should respond_to(:twitter_username) }
  it { should respond_to(:twitter_user_id) }
  it { should respond_to(:twitter_user_token) }
  it { should respond_to(:twitter_user_secret) }
  it { should respond_to(:facebook_user_id) }
  it { should respond_to(:facebook_access_token) }
  it { should respond_to(:instagram_username) }
  it { should respond_to(:instagram_user_id) }
  it { should respond_to(:instagram_user_token) }
  it { should respond_to(:teams) }
  it { should respond_to(:isConnectedToTwitter?)}
  
  it { should be_valid }
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
    invalid_addresses.each do |invalid_address|
      before { @user.email = invalid_address }
      it { should_not be_valid }
    end
  end

  describe "when email format is valid" do
    valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    valid_addresses.each do |valid_address|
      before { @user.email = valid_address }
      it { should be_valid }
    end
  end

  describe "when email address is already taken" do
    it "should raise error" do
      expect { User.create!(email:@user.email, password:"please", password_confirmation: "please") }.should raise_error
    end 
  end

  describe "when email address is already taken, different case" do
    it "should raise error" do
      expect { User.create!(email:@user.email.upcase, password:"please", password_confirmation: "please") }.should raise_error
    end 
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "can create user via facebook" do
    before do
      OmniAuth.config.mock_auth[:facebook] = { uid: '12345', info: { email:"foo@bar.com" }, credentials: { token: "access me" } }
      theHash = OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:facebook])
      @user = User.find_for_facebook_oauth( theHash, nil ) 
    end
    
    it { should be_valid }
  end
  
  describe "cannot create user via twitter" do
    before do
      OmniAuth.config.mock_auth[:twitter] = { uid: '12345', 
                                              info: { nickname: "foo@bar.com" }, 
                                              extra: { access_token: { token: "a token", secret: "a secret"} } 
                                              }
      theHash = OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:twitter])
      @user = User.find_for_twitter_oauth( theHash, nil ) 
    end
    
    it { should be_nil }
  end
  
  describe "can find existing user via twitter" do
    before do
      thePassword = Devise.friendly_token[0,20]
      theUserToFind = User.create!( email: 'twitter_init@fanzo.co', 
                                    password: thePassword,
                                    password_confirmation: thePassword,
                                    twitter_user_id: '12345' )
      theUserToFind.save

      OmniAuth.config.mock_auth[:twitter] = { uid: '12345', 
                                              info: { nickname: "jimbob" }, 
                                              extra: { access_token: { token: "a token", secret: "a secret"} } 
                                              }
      theHash = OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:twitter])
      @user = User.find_for_twitter_oauth( theHash, nil ) 
    end
    
    it "should have loaded the user to find" do
      @user.twitter_user_id.should eq('12345') 
    end
  end
  
  describe "can connect an existing user to twitter" do
    before do
      OmniAuth.config.mock_auth[:twitter] = { uid: '12345', 
                                              info: { nickname: "jimbob" }, 
                                              extra: { access_token: { token: "a token", secret: "a secret"} } 
                                              }
      @theHash = OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:twitter])
    end 
    
    it "should return the signed in user" do
      User.find_for_twitter_oauth( @theHash, @user ).should eq(@user)
    end   
    
    it "should add the twitter data" do
      User.find_for_twitter_oauth( @theHash, @user )
      
      theResult = User.where(email:@user.email).first
      theResult.twitter_username.should eq('jimbob')
      theResult.twitter_user_id.should eq('12345')
      theResult.twitter_user_token.should eq('a token')
      theResult.twitter_user_secret.should eq('a secret')
    end
  end
  
  describe "can find existing user via instagram" do
    before do
      thePassword = Devise.friendly_token[0,20]
      theUserToFind = User.create!( email: 'instagram_init@fanzo.co', 
                                    password: thePassword,
                                    password_confirmation: thePassword,
                                    instagram_user_id: '54321' )

      OmniAuth.config.mock_auth[:instagram] = { uid: '54321', 
                                              info: { nickname: "jimbob", name:"Jim Bob" }, 
                                              credentials: { token: "inst_token" } 
                                              }
      theHash = OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:instagram])
      @user = User.find_for_instagram_oauth( theHash, nil ) 
    end
    
    it "should have loaded the user to find" do
      @user.instagram_user_id.should eq('54321') 
    end
  end
  
  describe "can connect an existing user to instagram" do
    before do
      OmniAuth.config.mock_auth[:instagram] = { uid: '54321', 
                                              info: { nickname: "jimbob", name:"Jim Bob" }, 
                                              credentials: { token: "inst_token" } 
                                              }
      @theHash = OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:instagram])
    end 
    
    it "should return the signed in user" do
      User.find_for_instagram_oauth( @theHash, @user ).should eq(@user)
    end   
    
    it "should add the twitter data" do
      User.find_for_instagram_oauth( @theHash, @user )
      
      theResult = User.where(email:@user.email).first
      theResult.instagram_user_id.should eq('54321')
      theResult.instagram_user_token.should eq('inst_token')
      theResult.instagram_username.should eq('jimbob')
    end
  end
  
  describe "can add a team" do
    before do
      mock_geocoding!
      @team = FactoryGirl.create(:team)
    end
    
    it "and it should save properly" do
      theOriginalCount = UserTeam.all.count
      @user.teams.push(@team)
      @user.save
      UserTeam.all.count.should eq(theOriginalCount + 1)
    end
  end
  
  describe "isConnectedToTwitter?" do
    it "should return false when not connected to twitter" do
      theUser = FactoryGirl.create(:user)
      theUser.isConnectedToTwitter?.should be_false 
    end
    
    it "should return true when connected to twitter" do
      theUser = User.create(email:"joe@server.co", password:"please", password_confirmation: "please", twitter_user_token:'token', twitter_user_secret:'secret')
      theUser.isConnectedToTwitter?.should be_true
    end
  end
end
