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
    @social_info = FactoryGirl.build(:social_info, not_tags:"")
    theStub = stub_model(Team,
      :name => "killer team",
      :slug => "killer-team",
      :sport => @sport,
      :league => @league,
      :division => @division,
      :conference => @conference,
      :location => @location,
      :affiliation => @affiliation,
      :social_info => @social_info
    )
    @team = assign(:team, theStub)
    assign(:current_user, FactoryGirl.create(:user))
    
    @venue = FactoryGirl.build(:venue)
    @watch_site = FactoryGirl.build(:watch_site, team:@team, venue:@venue)
    @localTeamWatchSites = assign(:localTeamWatchSites, [@watch_site])
    render
  end

  it "renders attributes" do
    rendered.should match(/killer team/)
    rendered.should match(/#{@sport.name}/)
    rendered.should match(/#{@league.name}/)
    rendered.should match(/#{@division.name}/)
    rendered.should match(/#{@conference.name}/)
    rendered.should match(/#{@location.one_line_address}/)
    rendered.should match(/killer-team_l.gif/)
  end
  
  it "renders partial" do
    view.should render_template(partial:"_media_slider")
  end
end
