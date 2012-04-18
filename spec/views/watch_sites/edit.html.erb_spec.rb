require 'spec_helper'

describe "watch_sites/edit" do
  before(:each) do
    @theStubTeam = stub_model(Team, name:"Seahawks", id:1 )
    @theStubVenue = stub_model(Venue, name:"Eat At Joes", id:1)
    
    @watch_site = assign(:watch_site, stub_model(WatchSite,
      :name => "Superbowl Party",
      :team => @theStubTeam,
      :venue => @theStubVenue
    ))
  end

  it "renders the edit watch_site form" do
    Team.should_receive(:all).at_least(1).times.and_return([@theStubTeam])
    Venue.should_receive(:all).at_least(1).times.and_return([@theStubVenue])

    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => watch_sites_path(@watch_site), :method => "post" do
      assert_select "input#watch_site_name", :name => "watch_site[name]"
      
      assert_select "select#watch_site_team_id", :name => "watch_site[team_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#watch_site_venue_id", :name => "watch_site[venue_id]" do
        assert_select "option[selected]"
      end
    end
  end
end
