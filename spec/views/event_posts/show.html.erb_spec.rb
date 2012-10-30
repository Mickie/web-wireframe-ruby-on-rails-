require 'spec_helper'

describe "event_posts/show" do
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
    @event_post = assign(:event_post, stub_model(EventPost,
      :visiting_flag => false,
      :home_flag => true,
      :event => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
  end
end
