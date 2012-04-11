require 'spec_helper'

describe "teams/show" do
  before(:each) do
    mock_geocoding!
    @sport = FactoryGirl.build(:sport)
    @location = FactoryGirl.build(:location)
    @league = FactoryGirl.build(:league)
    @conference = FactoryGirl.build(:conference)
    @division = FactoryGirl.build(:division)
    @affiliation = FactoryGirl.build(:affiliation)
    theStub = stub_model(Team,
      :name => "Name",
      :sport => @sport,
      :league => @league,
      :division => @division,
      :conference => @conference,
      :location => @location,
      :affiliation => @affiliation ,
      :twitter_name => "Twitter Name",
      :facebook_page_url => "Facebook Page Url",
      :web_url => "Web Url"
    )
    @team = assign(:team, theStub)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/#{@sport.name}/)
    rendered.should match(/#{@league.name}/)
    rendered.should match(/#{@division.name}/)
    rendered.should match(/#{@conference.name}/)
    rendered.should match(/#{@location.name}/)
    rendered.should match(/Twitter Name/)
    rendered.should match(/Facebook Page Url/)
    rendered.should match(/Web Url/)
    rendered.should match(/#{@affiliation.name}/)
  end
end
