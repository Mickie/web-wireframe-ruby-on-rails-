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
  it { should respond_to(:user_comment_votes) }
  it { should respond_to(:user_post_votes) }
  it { should respond_to(:tailgates) }
  it { should respond_to(:isConnectedToTwitter?)}
  it { should respond_to(:full_name)}
  it { should respond_to(:latitude)}
  it { should respond_to(:longitude)}
  it { should respond_to(:hometown)}
  it { should respond_to(:location)}

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
  
  describe "getShortenedLocationQuery" do
    it "should handle various location strings" do
      @user.getShortenedLocationQuery("Seattle, WA").should eq("Seattle, WA")
      @user.getShortenedLocationQuery("Seattle, Washington").should eq("Seattle, WA")
      @user.getShortenedLocationQuery("Seattle").should eq("Seattle")
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

    describe "myFanzones" do
      it "should contain followed tailgates" do
        @user.myFanzones.should include( followed_tailgate )
      end      

      it "should contain owned tailgates" do
        owned_tailgate.save
        @user.myFanzones.should include( owned_tailgate )
      end      

      it "should not contain not_followed_or_owned_tailgate" do
        @user.myFanzones.should_not include( not_followed_or_owned_tailgate )
      end      
    end
    
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
        expect { User.create!(email:@user.email, password:"please", password_confirmation: "please") }.to raise_error
      end 
    end
  
    describe "when email address is already taken, different case" do
      it "should raise error" do
        expect { User.create!(email:@user.email.upcase, password:"please", password_confirmation: "please") }.to raise_error
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

  describe "updating from facebook data" do
    before do
      mock_geocoding!
    end
    
    let(:theData) { '{"id": "690891536", 
                      "name": "Paul Ingalls", 
                      "first_name": "Paul", 
                      "last_name": "Ingalls", 
                      "link": "https://www.facebook.com/paulingalls", 
                      "username": "paulingalls", 
                      "hometown": {
                        "id": "111723635511834", 
                        "name": "Bellevue, Washington"
                      }, 
                      "location": {
                        "id": "105506992816118", 
                        "name": "Kirkland, Washington"
                      },
                      "favorite_teams": [
                        {
                          "id": "155703994459155", 
                          "name": "Notre Dame Football"
                        }, 
                        {
                          "id": "34459843588", 
                          "name": "Seattle Sounders FC"
                        }, 
                        {
                          "id": "84249551721", 
                          "name": "Seattle Seahawks"
                        }, 
                        {
                          "id": "132551270119496", 
                          "name": "Notre Dame Fighting Irish"
                        }
                      ]
                    }' }
                    
    it "should handle empty data" do
      @user.updateFromFacebook("{}")
    end
    
    it "should save off the hometown" do
      @user.hometown.should be(nil)
      @user.updateFromFacebook(theData)
      @user.hometown.should eq("Bellevue, WA")
      @user.user_locations.find_by_location_query("Bellevue, WA").should_not be(nil)
    end
    
    it "should save off the location" do
      @user.location.should be(nil)
      @user.updateFromFacebook(theData)
      @user.location.should eq("Kirkland, WA")
      @user.user_locations.find_by_location_query("Kirkland, WA").should_not be(nil)
    end
    
    it "should add favorite teams" do
      theSounders = FactoryGirl.create(:team, name:"Seattle Sounders FC")
      theSeahawks = FactoryGirl.create(:team, name:"Seattle Seahawks")
      theIrish = FactoryGirl.create(:team, name:"Notre Dame Fighting Irish")
      @user.teams.length.should be(0)
      @user.updateFromFacebook(theData)
      @user.teams.length.should be(3)
    end
    
    it "doesn't add team if team already there" do
      theSounders = FactoryGirl.create(:team, name:"Seattle Sounders FC")
      theSeahawks = FactoryGirl.create(:team, name:"Seattle Seahawks")
      theIrish = FactoryGirl.create(:team, name:"Notre Dame Fighting Irish")
      @user.teams.push(theSounders)
      @user.save
      @user.teams.length.should be(1)
      @user.updateFromFacebook(theData)
      @user.teams.length.should be(3)
    end
  end

end
