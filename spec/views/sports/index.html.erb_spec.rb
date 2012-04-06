require 'spec_helper'

describe "sports/index" do
  before(:each) do
    assign(:sports, [
      stub_model(Sport),
      stub_model(Sport)
    ])
  end

  it "renders a list of sports" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
