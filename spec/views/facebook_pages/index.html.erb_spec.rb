require 'spec_helper'

describe "facebook_pages/index" do
  before(:each) do
    assign(:facebook_pages, [
      stub_model(FacebookPage),
      stub_model(FacebookPage)
    ])
  end

  it "renders a list of facebook_pages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
