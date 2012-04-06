require 'spec_helper'

describe "sports/new" do
  before(:each) do
    assign(:sport, stub_model(Sport).as_new_record)
  end

  it "renders new sport form" do
    render

    assert_select "form", :action => sports_path, :method => "post" do
    end

    view.should render_template( partial: "_form" )
    rendered.should have_selector('#sport_name')
    
  end
end
