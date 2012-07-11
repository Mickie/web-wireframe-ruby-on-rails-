require 'spec_helper'

describe Tailgate do
  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate)
  end 

  subject { @tailgate }
  
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:bitly) }
  it { should respond_to(:team) }
  it { should respond_to(:user) }
  it { should respond_to(:tailgate_venues) }
  it { should respond_to(:venues) }
  it { should respond_to(:posts) }
  it { should respond_to(:tailgate_followers) }
  it { should respond_to(:followers) }
  
  it "should require a name to validate" do
    @tailgate.name = nil
    @tailgate.should_not be_valid   
  end

  it "should require a user to validate" do
    @tailgate.user = nil
    @tailgate.should_not be_valid   
  end
  
  it "should have correct number of venues" do
    3.times do
      theVenue = FactoryGirl.create(:venue)
      @tailgate.tailgate_venues.create(venue_id:theVenue.id)
    end
    @tailgate.venues.length.should eq(3)
  end

  it "should have correct follower" do
    theUser = FactoryGirl.create(:user)
    theUser.follow!( @tailgate )
    theUser.should be_following(@tailgate)
    @tailgate.followers.should include( theUser )
  end
  
  it "should have correct number of tailgate_followers" do
    3.times do
      theUser = FactoryGirl.create(:user)
      theUser.follow!( @tailgate )
    end
    @tailgate.followers.length.should eq(3)
  end
  
  describe "light_color" do
    
    it "should return white for white color" do
      @tailgate.color = "#FFFFFF"
      @tailgate.light_color.should eq("white")
    end

    it "should return grey for black color" do
      @tailgate.color = "#000000"
      @tailgate.light_color.should eq("#bfbfbf")
    end
  end
  
end
