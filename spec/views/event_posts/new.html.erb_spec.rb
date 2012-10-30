require 'spec_helper'

describe "event_posts/new" do
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

    assign(:event_post, stub_model(EventPost,
      :visiting_post => nil,
      :home_post => nil,
      :event => nil
    ).as_new_record)
  end

  it "renders new event_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => event_event_posts_path(@event), :method => "post" do
      assert_select "input#event_post_visiting_flag", :name => "event_post[visiting_flag]"
      assert_select "input#event_post_home_flag", :name => "event_post[home_flag]"
    end
  end
end
