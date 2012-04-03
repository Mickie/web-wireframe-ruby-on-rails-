require 'spec_helper'

describe "static_pages/index" do
  it "should welcome to FANZO" do
    render
    rendered.should have_selector("h1", text:"FANZO")
  end
end
