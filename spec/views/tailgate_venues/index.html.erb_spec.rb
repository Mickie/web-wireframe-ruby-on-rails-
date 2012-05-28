require 'spec_helper'

describe "tailgate_venues/index" do
  before(:each) do
    @theVenue = stub_model(Venue, name:"joes")
    @theTailgate = stub_model(Tailgate, name:"party")
    assign(:tailgate_venues, [
      stub_model(TailgateVenue,
        :tailgate => @theTailgate,
        :venue => @theVenue,
        :latitude => 1.5,
        :longitude => 1.5
      ),
      stub_model(TailgateVenue,
        :tailgate => @theTailgate,
        :venue => @theVenue,
        :latitude => 1.5,
        :longitude => 1.5
      )
    ])
  end

  it "renders a list of tailgate_venues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "party", :count => 2
    assert_select "tr>td", :text => "joes", :count => 2
  end
end
