require 'spec_helper'

describe Team do
  before do
    mock_geocoding!
    @team = FactoryGirl.create(:team)
  end

  subject { @team }
  
  it { should respond_to(:name) }
  it { should respond_to(:sport) }
  it { should respond_to(:league) }
  it { should respond_to(:conference) }
  it { should respond_to(:division) } 
  it { should respond_to(:location) }
  it { should respond_to(:affiliation) }
  it { should respond_to(:social_info) }
  it { should respond_to(:events) }
  it { should respond_to(:athletes) }
  it { should respond_to(:coaches) }
  it { should respond_to(:journalists) }
  it { should respond_to(:superfans) }

  it "should have a latitude and longitude in its location" do
    @team.location.latitude.should_not be_nil  
    @team.location.longitude.should_not be_nil
  end
  
  describe "has many associations" do
    before do
      @home_event = FactoryGirl.create(:event, home_team: @team)
      @away_event = FactoryGirl.create(:event, visiting_team: @team)
    end
    
    it "should have the correct home_game" do
      @team.home_games.length.should eq(1)
      @team.home_games.first.should == @home_event
    end
    
    it "should have 1 away_game" do
      @team.away_games.length.should  eq(1)
      @team.away_games.first.should == @away_event
    end
    
    it "should have 2 events" do
      @team.events.length.should == 2
    end
  end
  
end
