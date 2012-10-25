require 'spec_helper'

describe "facebook_pages/new" do
  before(:each) do
    assign(:facebook_page, stub_model(FacebookPage).as_new_record)
  end

  it "renders new facebook_page form" do
    #render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "form", :action => facebook_pages_path, :method => "post" do
    #end
  end
end
