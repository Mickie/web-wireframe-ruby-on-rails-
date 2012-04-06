require 'spec_helper'

describe "sports/show" do
  before(:each) do
    @sport = assign(:sport, FactoryGirl.create(:sport))
  end

  it "renders attributes " do
    render
    rendered.should have_content(@sport.name)
  end
end
