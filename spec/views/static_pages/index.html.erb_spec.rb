require 'spec_helper'

describe "static_pages/index" do
  it "should welcome to FANZO" do
    view.stub(:signed_in?).and_return(false);
    render
    rendered.should have_selector("span.brand", text:"FANZO")
  end
end
