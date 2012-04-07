require 'spec_helper'

describe "sports/show" do
  before(:each) do
    @sport = assign(:sport, FactoryGirl.create(:sport, leagues:[FactoryGirl.create(:league)]))
  end

  it "renders attributes " do
    render
    rendered.should have_content(@sport.name)
    rendered.should have_content(@sport.leagues.first.name)
  end
end
