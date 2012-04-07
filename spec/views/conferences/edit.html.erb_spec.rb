require 'spec_helper'

describe "conferences/edit" do
  before(:each) do
    @conference = assign(:conference, stub_model(Conference,
      :name => "MyString",
      :league_id => 1
    ))
  end

  it "renders the edit conference form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => conferences_path(@conference), :method => "post" do
      assert_select "input#conference_name", :name => "conference[name]"
      assert_select "select#conference_league_id", :name => "conference[league_id]"
    end
    
    rendered.should have_selector('#commit')
    
  end
end
