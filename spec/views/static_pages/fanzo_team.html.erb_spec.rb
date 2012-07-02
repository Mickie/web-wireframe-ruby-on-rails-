require 'spec_helper'

describe "static_pages/fanzo_team" do
  it "should say FANZO" do
    render
    rendered.should have_content("FANZO")
  end
end
