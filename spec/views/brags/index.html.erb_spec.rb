require 'spec_helper'

describe "brags/index" do
  before(:each) do
    assign(:brags, [
      stub_model(Brag,
        :content => "Content"
      ),
      stub_model(Brag,
        :content => "Content"
      )
    ])
  end

  it "renders a list of brags" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Content".to_s, :count => 2
  end
end
