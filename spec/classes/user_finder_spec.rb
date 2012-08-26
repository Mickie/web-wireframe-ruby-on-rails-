require 'spec_helper'

describe UserFinder do

  before do
    @user = FactoryGirl.create(:user)
  end
  
  subject { @user }

  describe "twitter integration" do
    before do
      @theHash = twitter_auth
    end
    

    describe "cannot create user via twitter" do
      before do
        @user = UserFinder.find_for_twitter_oauth( @theHash, nil ) 
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
        theResult = UserFinder.find_for_twitter_oauth( @theHash, nil ) 
        theResult.should eq(@theUserToFind) 
      end

    end
    
    describe "can connect an existing user to twitter" do
      it "should return the signed in user" do
        UserFinder.find_for_twitter_oauth( @theHash, @user ).should eq(@user)
      end   
      
      it "should add the twitter data" do
        UserFinder.find_for_twitter_oauth( @theHash, @user )
        
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
        
        theResult = UserFinder.find_for_twitter_oauth( @theHash, @user ) 
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
  
        @user = UserFinder.find_for_instagram_oauth( @theHash, nil ) 
      end
      
      it "should have loaded the user to find" do
        @user.should eq(@theUserToFind) 
      end
    end
    
    describe "can connect an existing user to instagram" do
      
      it "should return the signed in user" do
        UserFinder.find_for_instagram_oauth( @theHash, @user ).should eq(@user)
      end   
      
      it "should add the instagram data" do
        UserFinder.find_for_instagram_oauth( @theHash, @user )
        
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
        
        theResult = UserFinder.find_for_instagram_oauth( @theHash, @user ) 
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
        @user = UserFinder.find_for_facebook_oauth( @theHash, nil ) 
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
        UserFinder.find_for_facebook_oauth( @theHash, nil ).should eq(@theUserToFind) 
      end

      it "returns newly authed user if signed in user" do
        UserFinder.find_for_facebook_oauth( @theHash, @user ).should eq(@theUserToFind) 
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
        UserFinder.find_for_facebook_oauth( @theHash, nil ).should eq(@theUserToFind) 
      end

      it "should add the facebook data" do
        UserFinder.find_for_facebook_oauth( @theHash, nil )
        
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
        UserFinder.find_for_facebook_oauth( @theHash, @user ).should eq(@user)
      end   
      
      it "should add the facebook data" do
        theReturn = UserFinder.find_for_facebook_oauth( @theHash, @user )
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
        
        theResult = UserFinder.find_for_facebook_oauth( @theHash, @user ) 
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
        @user = UserFinder.find_for_foursquare_oauth( @theHash, nil ) 
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
        UserFinder.find_for_foursquare_oauth( @theHash, nil ).should eq(@theUserToFind) 
      end

      it "returns newly authed user if signed in user" do
        UserFinder.find_for_foursquare_oauth( @theHash, @user ).should eq(@theUserToFind) 
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
        UserFinder.find_for_foursquare_oauth( @theHash, nil ).should eq(@theUserToFind) 
      end

      it "should add the foursquare data" do
        UserFinder.find_for_foursquare_oauth( @theHash, nil )
        
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
        UserFinder.find_for_foursquare_oauth( @theHash, @user ).should eq(@user)
      end   
      
      it "should add the foursquare data" do
        theReturn = UserFinder.find_for_foursquare_oauth( @theHash, @user )
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
        
        theResult = UserFinder.find_for_foursquare_oauth( @theHash, @user ) 
        theResult.first_name.should eq("original")
        theResult.last_name.should eq("original")
        theResult.image.should eq("original")
      end
    end
    
  end

  describe "findOrCreateUserFromFacebookId" do
    let(:theExistingUser){ FactoryGirl.create(:user, facebook_user_id: "12345")}
    let(:theNewUser){ FactoryGirl.create(:user)}

    it "should find an existing user" do
      theExistingUser.save
      UserFinder.findOrCreateUserFromFacebookId("12345", "54321").should eq(theExistingUser)     
    end

    it "should create a new user if not found" do
      UserFinder.should_receive(:createUserFromProfile).once.with("12345", "54321").and_return(theNewUser)
      UserFinder.findOrCreateUserFromFacebookId("12345", "54321").should eq(theNewUser)     
    end

  end

  describe "createUserFromProfile" do
    
    before do
      theFacebookDouble = double(Koala::Facebook::API)
      Koala::Facebook::API.stub(:new).and_return(theFacebookDouble)
      theFakeResponse = MultiJson.load('{ "email":"foo@bar.com", "first_name":"foo", "last_name":"bar", "name":"baz" }')
      theFacebookDouble.should_receive(:get_object).once.with("me").and_return(theFakeResponse)    
    end
    
    it "should create a new user with data from facebook" do
      theUser = UserFinder.createUserFromProfile("12345", "54321")
      theUser.first_name.should eq("foo")
      theUser.last_name.should eq("bar")
      theUser.name.should eq("baz")
      theUser.email.should eq("foo@bar.com")
      theUser.facebook_user_id.should eq("12345")
      theUser.facebook_access_token.should eq("54321")
    end
    
  end

  
end
