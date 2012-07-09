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
  it { should respond_to(:foursquare_user_id) }
  it { should respond_to(:foursquare_access_token) }
  it { should respond_to(:instagram_username) }
  it { should respond_to(:instagram_user_id) }
  it { should respond_to(:instagram_user_token) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:name) }
  it { should respond_to(:image) }
  it { should respond_to(:description) }
  it { should respond_to(:teams) }
  it { should respond_to(:user_locations) }
  it { should respond_to(:locations) }
  it { should respond_to(:tailgates) }
  it { should respond_to(:isConnectedToTwitter?)}
  it { should respond_to(:full_name)}

  it { should respond_to(:tailgate_followers)}
  it { should respond_to(:followed_tailgates)}
  it { should respond_to(:following?)}
  it { should respond_to(:follow!)}
  it { should respond_to(:unfollow!)}
  
  
  it { should be_valid }
  
  describe "full_name" do
    it "should return name if exists" do
      @user.name = "aName"
      @user.full_name.should eq("aName")
    end
    
    it "should return combo of first and last if name is empty" do
      @user.first_name = "First"
      @user.last_name = "Last"
      @user.full_name.should eq("First Last")
    end
    
    it "should fall back to email if no other name parts" do
      @user.full_name.should eq(@user.email)
    end
  end
  
  describe "following a tailgate" do
    let(:tailgate) { FactoryGirl.create(:tailgate) }
    before do
      mock_geocoding!
      @user.follow!( tailgate )
    end 
    
    it { should be_following( tailgate ) }
    its(:followed_tailgates) { should include(tailgate) }
    
    describe "and unfollowing" do
      before { @user.unfollow!( tailgate ) }

      it { should_not be_following( tailgate ) }
      its(:followed_tailgates) { should_not include( tailgate ) }
    end    
  end
  
  describe "tailgate relationships" do
    let(:followed_tailgate) { FactoryGirl.create(:tailgate) }
    let(:not_followed_or_owned_tailgate) { FactoryGirl.create(:tailgate) }
    let(:owned_tailgate) { FactoryGirl.create(:tailgate, user_id:@user.id) }
    
    before do
      mock_geocoding!
      @user.follow!( followed_tailgate )
    end
    
    it { should be_mine( owned_tailgate ) }
    it { should_not be_mine( followed_tailgate ) }
    it { should_not be_mine( not_followed_or_owned_tailgate ) }

    it { should_not be_following( owned_tailgate ) }
    it { should be_following( followed_tailgate ) }
    it { should_not be_following( not_followed_or_owned_tailgate ) }    
    
    it { should be_mine_or_following( followed_tailgate ) }
    it { should be_mine_or_following( owned_tailgate ) }
    it { should_not be_mine_or_following( not_followed_or_owned_tailgate ) }
    
  end
  
  describe "email validation" do
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
  end
  
  describe "password validation" do
  
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
  end

  describe "twitter integration" do
    before do
      @theHash = twitter_auth
    end
    

    describe "cannot create user via twitter" do
      before do
        @user = User.find_for_twitter_oauth( @theHash, nil ) 
      end
      
      it { should be_nil }
    end

    describe "can find existing user via twitter" do
      before do
        thePassword = Devise.friendly_token[0,20]
        @theUserToFind = User.create!( email: 'twitter_init@fanzo.me', 
                                      password: thePassword,
                                      password_confirmation: thePassword,
                                      twitter_user_id: '12345' )
        @theUserToFind.save
  
      end
      
      it "should have loaded the user to find" do
        theResult = User.find_for_twitter_oauth( @theHash, nil ) 
        theResult.should eq(@theUserToFind) 
      end

    end
    
    describe "can connect an existing user to twitter" do
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
        theResult.description.should eq("he is a cool dude")
        theResult.image.should eq("image url")
        theResult.name.should eq("Jim Bob")
      end

      it "should not overwrite existing data" do
        @user.description = "original"
        @user.image = "original"
        @user.name = "original"
        @user.save
        
        theResult = User.find_for_twitter_oauth( @theHash, @user ) 
        theResult.description.should eq("original")
        theResult.image.should eq("original")
        theResult.name.should eq("original")
      end

    end
  end
  
  describe "instagram integration" do

    before do
      @theHash = instagram_auth
    end
  
    describe "can find existing user via instagram" do
      before do
        thePassword = Devise.friendly_token[0,20]
        @theUserToFind = User.create!( email: 'instagram_init@fanzo.me', 
                                      password: thePassword,
                                      password_confirmation: thePassword,
                                      instagram_user_id: '54321' )
  
        @user = User.find_for_instagram_oauth( @theHash, nil ) 
      end
      
      it "should have loaded the user to find" do
        @user.should eq(@theUserToFind) 
      end
    end
    
    describe "can connect an existing user to instagram" do
      
      it "should return the signed in user" do
        User.find_for_instagram_oauth( @theHash, @user ).should eq(@user)
      end   
      
      it "should add the instagram data" do
        User.find_for_instagram_oauth( @theHash, @user )
        
        theResult = User.where(email:@user.email).first
        theResult.instagram_user_id.should eq('54321')
        theResult.instagram_user_token.should eq('inst_token')
        theResult.instagram_username.should eq('jimbob')
        theResult.description.should eq("jim is a cool dude")
        theResult.image.should eq("image url")
        theResult.name.should eq("Jim Bob")
      end

      it "should not overwrite existing data" do
        @user.description = "original"
        @user.image = "original"
        @user.name = "original"
        @user.save
        
        theResult = User.find_for_twitter_oauth( @theHash, @user ) 
        theResult.description.should eq("original")
        theResult.image.should eq("original")
        theResult.name.should eq("original")
      end
    end
  end

  describe "facebook integration" do
    before do
      @theHash = facebook_auth
    end
  

    describe "can create user via facebook" do
      before do
        mock_geocoding!
        @fanzoTailgate = FactoryGirl.create(:tailgate, name:"The World's Largest Tailgate Party!")
        @user = User.find_for_facebook_oauth( @theHash, nil ) 
      end
      
      it "should create a user" do
        @user.should be_valid
        
        theResult = User.where(facebook_user_id: '54321').first
        theResult.should be_valid
        theResult.should eq(@user)
        theResult.email.should eq("facebook_init@fanzo.me")
        theResult.facebook_access_token.should eq("facebook_token")
        theResult.image.should eq("image url")
        theResult.last_name.should eq("last")
        theResult.first_name.should eq("first")
        theResult.following?(@fanzoTailgate).should be_true
      end
    end
  
    describe "can find existing user via facebook id" do
      before do
        thePassword = Devise.friendly_token[0,20]
        @theUserToFind = User.create!( email: 'facebook_init@fanzo.me', 
                                      password: thePassword,
                                      password_confirmation: thePassword,
                                      facebook_user_id: '54321' )
      end
      
      it "should have loaded the user to find" do
        User.find_for_facebook_oauth( @theHash, nil ).should eq(@theUserToFind) 
      end

      it "returns newly authed user if signed in user" do
        User.find_for_facebook_oauth( @theHash, @user ).should eq(@theUserToFind) 
      end

    end
    
    describe "can find existing user via email" do
      before do
        thePassword = Devise.friendly_token[0,20]
        @theUserToFind = User.create!( email: 'facebook_init@fanzo.me', 
                                      password: thePassword,
                                      password_confirmation: thePassword )
      end
      
      it "should have loaded the user to find" do
        User.find_for_facebook_oauth( @theHash, nil ).should eq(@theUserToFind) 
      end

      it "should add the facebook data" do
        User.find_for_facebook_oauth( @theHash, nil )
        
        theResult = User.where(email:@theUserToFind.email).first
        theResult.should eq(@theUserToFind)
        theResult.facebook_user_id.should eq('54321')
        theResult.facebook_access_token.should eq('facebook_token')
        theResult.image.should eq("image url")
        theResult.last_name.should eq("last")
        theResult.first_name.should eq("first")
      end

    end

    describe "connecting an existing user to facebook" do
      
      it "should return the signed in user if ids match" do
        @user.facebook_user_id = '54321'
        @user.save
        User.find_for_facebook_oauth( @theHash, @user ).should eq(@user)
      end   
      
      it "should add the facebook data" do
        theReturn = User.find_for_facebook_oauth( @theHash, @user )
        theReturn.should eq(@user)
        
        theResult = User.where(email:@user.email).first
        theResult.should eq(@user)
        theResult.facebook_user_id.should eq('54321')
        theResult.facebook_access_token.should eq('facebook_token')
        theResult.image.should eq("image url")
        theResult.last_name.should eq("last")
        theResult.first_name.should eq("first")
      end

      it "should not overwrite existing data" do
        @user.first_name = "original"
        @user.last_name = "original"
        @user.image = "original"
        @user.save
        
        theResult = User.find_for_twitter_oauth( @theHash, @user ) 
        theResult.first_name.should eq("original")
        theResult.last_name.should eq("original")
        theResult.image.should eq("original")
      end
    end
    
  end

  describe "foursquare integration" do
    before do
      @theHash = foursquare_auth
    end
  
    describe "can create user via foursquare" do
      before do
        mock_geocoding!
        @fanzoTailgate = FactoryGirl.create(:tailgate, name:"The World's Largest Tailgate Party!")
        @user = User.find_for_foursquare_oauth( @theHash, nil ) 
      end
      
      it "should create a user" do
        @user.should be_valid
        
        theResult = User.where(foursquare_user_id: '54321').first
        theResult.should be_valid
        theResult.should eq(@user)
        theResult.email.should eq("foursquare_init@fanzo.me")
        theResult.foursquare_access_token.should eq("foursquare_token")
        theResult.image.should eq("image url")
        theResult.last_name.should eq("last")
        theResult.first_name.should eq("first")
        theResult.should be_following(@fanzoTailgate)
      end
    end

    describe "can find existing user via foursquare id" do
      before do
        thePassword = Devise.friendly_token[0,20]
        @theUserToFind = User.create!( email: 'foursquare_init@fanzo.me', 
                                      password: thePassword,
                                      password_confirmation: thePassword,
                                      foursquare_user_id: '54321' )
      end
      
      it "should have loaded the user to find" do
        User.find_for_foursquare_oauth( @theHash, nil ).should eq(@theUserToFind) 
      end

      it "returns newly authed user if signed in user" do
        User.find_for_foursquare_oauth( @theHash, @user ).should eq(@theUserToFind) 
      end

    end
    
    describe "can find existing user via email" do
      before do
        thePassword = Devise.friendly_token[0,20]
        @theUserToFind = User.create!( email: 'foursquare_init@fanzo.me', 
                                      password: thePassword,
                                      password_confirmation: thePassword )
      end
      
      it "should have loaded the user to find" do
        User.find_for_foursquare_oauth( @theHash, nil ).should eq(@theUserToFind) 
      end

      it "should add the foursquare data" do
        User.find_for_foursquare_oauth( @theHash, nil )
        
        theResult = User.where(email:@theUserToFind.email).first
        theResult.should eq(@theUserToFind)
        theResult.foursquare_user_id.should eq('54321')
        theResult.foursquare_access_token.should eq('foursquare_token')
        theResult.image.should eq("image url")
        theResult.last_name.should eq("last")
        theResult.first_name.should eq("first")
      end
    end


    describe "connecting an existing user to foursquare" do
      
      it "should return the signed in user if ids match" do
        @user.foursquare_user_id = '54321'
        @user.save
        User.find_for_foursquare_oauth( @theHash, @user ).should eq(@user)
      end   
      
      it "should add the foursquare data" do
        theReturn = User.find_for_foursquare_oauth( @theHash, @user )
        theReturn.should eq(@user)
        
        theResult = User.where(email:@user.email).first
        theResult.should eq(@user)
        theResult.foursquare_user_id.should eq('54321')
        theResult.foursquare_access_token.should eq('foursquare_token')
        theResult.image.should eq("image url")
        theResult.last_name.should eq("last")
        theResult.first_name.should eq("first")
      end

      it "should not overwrite existing data" do
        @user.first_name = "original"
        @user.last_name = "original"
        @user.image = "original"
        @user.save
        
        theResult = User.find_for_twitter_oauth( @theHash, @user ) 
        theResult.first_name.should eq("original")
        theResult.last_name.should eq("original")
        theResult.image.should eq("original")
      end
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
