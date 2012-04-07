require 'spec_helper'

describe "leagues/new" do
  before(:each) do
    assign(:league, stub_model(League,
      :name => "NFL"
    ).as_new_record)
    assign(:allSports, [stub_model(Sport, name:"football")])
  end

  it "renders new league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => leagues_path, :method => "post" do
      assert_select "input#league_name", :name => "league[name]"
    end
    
    rendered.should have_selector('#commit')
    
  end
end
