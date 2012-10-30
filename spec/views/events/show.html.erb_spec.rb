require 'spec_helper'

describe "events/show" do
  before(:each) do
    theSportStub = stub_model(Sport, name:"Football", id:1)
    theSocialInfoStub = stub_model(SocialInfo, hash_tags:"#foo", not_tags:"#bar")
    theStub = stub_model(Event,
      :name => "Superbowl",
      :home_team => stub_model(Team, name:"Seahawks", slug:"seahawks", sport:theSportStub, social_info: theSocialInfoStub),
      :visiting_team => stub_model(Team, name:"Cowboys", slug:"cowboys", sport:theSportStub, social_info: theSocialInfoStub),
      :location => stub_model(Location, one_line_address:"100 Main"),
      :event_date => DateTime.now(),
      :event_time => Time.now
    )
    @event = assign(:event, theStub)
    @event_post = assign(:event_post, stub_model(EventPost))
    
    assign(:current_user, FactoryGirl.create(:user))
    view.stub(:user_signed_in?).and_return(false);

    @visitingTailgate = assign(:visitingTailgate, FactoryGirl.build(:tailgate, team: @event.visiting_team, official:true, id:1))
    @homeTailgate = assign(:homeTailgate, FactoryGirl.build(:tailgate, team: @event.home_team, official:true, id:2))
    
    @venue = FactoryGirl.build(:venue)
    @home_watch_site = FactoryGirl.build(:watch_site, team:@event.home_team, venue:@venue)
    @visiting_watch_site = FactoryGirl.build(:watch_site, name:"", team:@event.visiting_team, venue:@venue)
    @localHomeTeamWatchSites = assign(:localHomeTeamWatchSites, [@home_watch_site])
    @localVisitingTeamWatchSites = assign(:localVisitingTeamWatchSites, [@visiting_watch_site])
    
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Seahawks/)
    rendered.should match(/Cowboys/)
  end
  
  it "handles a nil time" do
    @event.event_time = nil;
    render
    rendered.should match(/Seahawks/)
  end
  
  # it "shows watch sites" do
    # render
    # rendered.should match(/#{@home_watch_site.name}/)
    # rendered.should match(/#{@visiting_watch_site.venue.name}/)
  # end  
end
