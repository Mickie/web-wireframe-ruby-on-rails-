require 'spec_helper'

describe "watch_sites/show" do
  before(:each) do
    @theStubTeam = stub_model(Team, name:"Seahawks", id:1 )
    @theStubVenue = stub_model(Venue, name:"Eat At Joes", id:1)
    
    @watch_site = assign(:watch_site, stub_model(WatchSite,
      :name => "hawkers site",
      :team => @theStubTeam,
      :venue => @theStubVenue
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Seahawks/)
    rendered.should match(/Eat At Joes/)
  end
end
