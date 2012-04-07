require 'spec_helper'

describe "static_pages/contact.html.erb" do
  it "should say contact" do
    render
    rendered.should have_content("contact")
  end
end
