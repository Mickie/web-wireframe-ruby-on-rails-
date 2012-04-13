require 'spec_helper'

describe "divisions/edit" do
  before(:each) do
    @league = FactoryGirl.create(:league)
    @division = assign(:division, stub_model(Division,
      :name => "AFC West",
      :league_id => @league.id
    ))
  end

  it "renders the edit division form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => divisions_path(@division), :method => "post" do
      assert_select "input#division_name", :name => "division[name]"
      assert_select "select#division_league_id", :name => "division[league_id]" do
        assert_select "option[selected]"
      end
    end

    rendered.should have_selector('#commit')
    
  end
end
