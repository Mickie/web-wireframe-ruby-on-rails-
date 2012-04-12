require 'spec_helper'

describe "venue_types/edit" do
  before(:each) do
    @venue_type = assign(:venue_type, stub_model(VenueType,
      :name => "MyString"
    ))
  end

  it "renders the edit venue_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => venue_types_path(@venue_type), :method => "post" do
      assert_select "input#venue_type_name", :name => "venue_type[name]"
    end
  end
end
