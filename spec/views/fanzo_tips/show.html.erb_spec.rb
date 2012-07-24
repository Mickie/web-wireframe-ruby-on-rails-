require 'spec_helper'

describe "fanzo_tips/show" do
  before(:each) do
    @fanzo_tip = assign(:fanzo_tip, stub_model(FanzoTip,
      :name => "Name",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
  end
end
