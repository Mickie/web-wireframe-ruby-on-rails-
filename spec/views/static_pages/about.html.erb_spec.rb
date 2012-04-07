require 'spec_helper'

describe "static_pages/about.html.erb" do
  it "should say about" do
    render
    rendered.should have_content("about")
  end
end
