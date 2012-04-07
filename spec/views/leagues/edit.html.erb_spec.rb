require 'spec_helper'

describe "leagues/edit" do
  before(:each) do
    @league = assign(:league, stub_model(League,
      :name => "NHL"
    ))
    assign(:allSports, [stub_model(Sport, name:"hockey")])
  end

  it "renders the edit league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => leagues_path(@league), :method => "post" do
      assert_select "input#league_name", :name => "league[name]"
    end
  end
end
