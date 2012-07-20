require 'spec_helper'

describe Team do
  before do
    mock_geocoding!
    @team = FactoryGirl.create(:team, name:"xxxx")
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
  it { should respond_to(:watch_sites) }
  it { should respond_to(:venues) }
  it { should respond_to(:espn_team_id) }
  it { should respond_to(:espn_team_url) }
  it { should respond_to(:slug) } 
  it { should respond_to(:short_name) } 
  it { should respond_to(:mascot) } 
  it { should respond_to(:espn_team_name_id) }
  it { should respond_to(:large_logo_bitly) }
  it { should respond_to(:tailgates) } 

  it "should have a latitude and longitude in its location" do
    @team.location.latitude.should_not be_nil  
    @team.location.longitude.should_not be_nil
  end
  
  describe "teams are ordered alphabetically" do
    let!(:team2) { FactoryGirl.create(:team, name:"gggg")}
    let!(:team3) { FactoryGirl.create(:team, name:"bbbb")}
    
    it "should have lowest letter first" do
      Team.all.count.should eq(3)
      Team.all.first.should eq(team3)
    end
  end
  
  describe "has many associations" do
    before do
      @home_event = FactoryGirl.create(:event, home_team: @team, event_date: Date.tomorrow)
      @away_event = FactoryGirl.create(:event, visiting_team: @team, event_date: Date.today)
    end
    
    it "should have the correct home_game" do
      @team.home_games.length.should eq(1)
      @team.home_games.first.should == @home_event
    end
    
    it "should have 1 away_game" do
      @team.away_games.length.should  eq(1)
      @team.away_games.first.should == @away_event
    end
    
    it "should have 2 events and they should be sorted by date" do
      @team.events.length.should eq(2)
      @team.events[0].should eq(@away_event)
      @team.events[1].should eq(@home_event)
    end
    
    it "should have watch_sites" do
      4.times do
        theWatchSite = FactoryGirl.create(:watch_site, team: @team)
      end      

      @team.watch_sites.length.should == 4
    end

    it "should have venues" do
      3.times do
        theWatchSite = FactoryGirl.create(:watch_site, team: @team)
      end      

      @team.venues.length.should == 3
    end
  
    it "should have tailgates" do
      2.times do
        theTailgate = FactoryGirl.create(:tailgate, team: @team)
      end
      
      @team.tailgates.length.should == 2
    end
  end
  
end
