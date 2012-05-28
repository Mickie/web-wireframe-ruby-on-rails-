require 'spec_helper'

describe "tailgate_venues/new" do
  before(:each) do
    assign(:tailgate_venue, stub_model(TailgateVenue,
      :tailgate => nil,
      :venue => nil,
      :latitude => 1.5,
      :longitude => 1.5
    ).as_new_record)
  end

  it "renders new tailgate_venue form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tailgate_venues_path, :method => "post" do
      assert_select "select#tailgate_venue_venue_id", :name => "tailgate_venue[venue_id]"
      assert_select "select#tailgate_venue_tailgate_id", :name => "tailgate_venue[tailgate_id]"
    end
  end
end
