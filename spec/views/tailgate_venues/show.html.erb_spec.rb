require 'spec_helper'

describe "tailgate_venues/show" do
  before(:each) do
    @theVenue = stub_model(Venue, name:"joes")
    @theTailgate = stub_model(Tailgate, name:"party")
    @tailgate_venue = assign(:tailgate_venue, stub_model(TailgateVenue,
      :tailgate => @theTailgate,
      :venue => @theVenue,
      :latitude => 1.5,
      :longitude => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
