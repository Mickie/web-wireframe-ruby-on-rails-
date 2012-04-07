require 'spec_helper'

describe "divisions/index" do
  before(:each) do
    @league = FactoryGirl.create(:league)
    assign(:divisions, [
      stub_model(Division,
        :name => "Name",
        :league => @league
      ),
      stub_model(Division,
        :name => "Name",
        :league => @league
      )
    ])
  end

  it "renders a list of divisions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => @league.name, :count => 2
  end
end
