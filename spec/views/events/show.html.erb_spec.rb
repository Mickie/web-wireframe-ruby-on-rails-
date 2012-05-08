require 'spec_helper'

describe "events/show" do
  before(:each) do
    theStub = stub_model(Event,
      :name => "Superbowl",
      :home_team => stub_model(Team, name:"Seahawks", slug:"seahawks"),
      :visiting_team => stub_model(Team, name:"Cowboys", slug:"cowboys"),
      :location => stub_model(Location, one_line_address:"100 Main"),
      :event_date => DateTime.now(),
      :event_time => Time.now
    )
    @event = assign(:event, theStub)
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Seahawks/)
    rendered.should match(/Cowboys/)
    rendered.should match(/100 Main/)
  end
  
  it "handles a nil time" do
    @event.event_time = nil;
    render
    rendered.should match(/Seahawks/)
  end  
end
