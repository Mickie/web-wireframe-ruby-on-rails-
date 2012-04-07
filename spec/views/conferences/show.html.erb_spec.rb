require 'spec_helper'

describe "conferences/show" do
  before(:each) do
    @league = FactoryGirl.create(:league)
    @conference = assign(:conference, stub_model(Conference,
      :name => "Name",
      :league => @league
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/#{@league.name}/)
  end
end
