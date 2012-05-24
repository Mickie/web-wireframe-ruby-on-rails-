require 'spec_helper'

describe "tailgates/show" do
  before(:each) do
    @team = stub_model(Team, id:1, name:"Seahawks")
    @user = stub_model(User, email:"Joe@bar.com")
    @tailgate = assign(:tailgate, stub_model(Tailgate,
      :name => "Name",
      :user => @user,
      :team => @team
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Joe@bar.com/)
    rendered.should match(/Seahawks/)
  end
end
