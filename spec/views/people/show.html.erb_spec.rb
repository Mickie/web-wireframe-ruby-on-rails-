require 'spec_helper'

describe "people/show" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :first_name => "First Name",
      :last_name => "Last Name",
      :home_town => "Home Town",
      :home_school => "Home School",
      :position => "Position",
      :social_info => nil,
      :team => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Home Town/)
    rendered.should match(/Home School/)
    rendered.should match(/Position/)
    rendered.should match(//)
    rendered.should match(//)
  end
end
