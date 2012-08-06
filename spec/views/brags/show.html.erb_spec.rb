require 'spec_helper'

describe "brags/show" do
  before(:each) do
    @brag = assign(:brag, stub_model(Brag,
      :content => "Content"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Content/)
  end
end
