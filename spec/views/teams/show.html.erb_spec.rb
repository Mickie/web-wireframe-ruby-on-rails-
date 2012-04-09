require 'spec_helper'

describe "teams/show" do
  before(:each) do
    @team = assign(:team, stub_model(Team,
      :name => "Name",
      :sport => nil,
      :league => nil,
      :division => nil,
      :conference => nil,
      :location => nil,
      :twitter_name => "Twitter Name",
      :facebook_page_url => "Facebook Page Url",
      :web_url => "Web Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Twitter Name/)
    rendered.should match(/Facebook Page Url/)
    rendered.should match(/Web Url/)
  end
end
