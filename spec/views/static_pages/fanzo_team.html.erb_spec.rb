require 'spec_helper'

describe "static_pages/fanzo_team" do
  it "should say Fanzo" do
    render
    rendered.should have_content("Fanzo")
  end
end
