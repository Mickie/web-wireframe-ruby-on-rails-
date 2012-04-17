require 'spec_helper'

describe "watch_sites/show" do
  before(:each) do
    @watch_site = assign(:watch_site, stub_model(WatchSite,
      :name => "Name",
      :team => nil,
      :venue => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(//)
    rendered.should match(//)
  end
end
