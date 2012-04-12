require 'spec_helper'

describe "venue_types/show" do
  before(:each) do
    @venue_type = assign(:venue_type, stub_model(VenueType,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
