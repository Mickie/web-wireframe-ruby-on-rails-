require 'spec_helper'

describe "facebook_pages/edit" do
  before(:each) do
    @facebook_page = assign(:facebook_page, stub_model(FacebookPage))
  end

  it "renders the edit facebook_page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => facebook_pages_path(@facebook_page), :method => "post" do
    end
  end
end
