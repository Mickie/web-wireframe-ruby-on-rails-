require 'spec_helper'

describe "leagues/edit" do
  before(:each) do
    @sport1 = FactoryGirl.create(:sport)
    @sport2 = FactoryGirl.create(:sport)
    @league = assign(:league, stub_model(League,
      :name => "NHL",
      :sport_id => @sport2.id
    ))
  end

  it "renders the edit league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => leagues_path(@league), :method => "post" do
      assert_select "input#league_name", { :name => "league[name]" }
      assert_select "input#league_visible", { :name => "league[visible]" }
      assert_select "select#league_sport_id", :name => "league[sport_id]" do
        assert_select "option[selected]"
      end
    end

    rendered.should have_selector('#commit')

  end
end
