require 'spec_helper'

describe "tailgates/index" do
  before(:each) do
    @team = stub_model(Team, id:1, name:"Seahawks")
    assign(:tailgates, [
      stub_model(Tailgate,
        :name => "Name",
        :team => @team
      ),
      stub_model(Tailgate,
        :name => "Name",
        :team => @team
      )
    ])
  end

  it "renders a list of tailgates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name", :count => 2
    assert_select "tr>td", :text => "Seahawks", :count => 2
  end
end
