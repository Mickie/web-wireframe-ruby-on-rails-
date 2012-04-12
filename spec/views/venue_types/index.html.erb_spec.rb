require 'spec_helper'

describe "venue_types/index" do
  before(:each) do
    assign(:venue_types, [
      stub_model(VenueType,
        :name => "Name"
      ),
      stub_model(VenueType,
        :name => "Name"
      )
    ])
  end

  it "renders a list of venue_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
