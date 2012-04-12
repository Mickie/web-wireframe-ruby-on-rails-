require 'spec_helper'

describe "venue_types/new" do
  before(:each) do
    assign(:venue_type, stub_model(VenueType,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new venue_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => venue_types_path, :method => "post" do
      assert_select "input#venue_type_name", :name => "venue_type[name]"
    end
  end
end
