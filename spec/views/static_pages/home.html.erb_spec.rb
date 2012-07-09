require 'spec_helper'

describe "static_pages/home" do
  before do
    @tailgates = []
    view.stub(:user_signed_in?).and_return(false);
  end

  it "should have a container of tiles" do
    render
    rendered.should have_selector("div#allTiles")
  end
end
