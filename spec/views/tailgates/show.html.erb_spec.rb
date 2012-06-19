require 'spec_helper'

describe "tailgates/show" do
  before(:each) do
    @social_info = stub_model(SocialInfo, hash_tags: "#goirish", not_tags:"")
    @sport = stub_model(Sport, id:1)
    @team = stub_model(Team, id:1, name:"Seahawks", social_info:@social_info, sport:@sport)
    @user = stub_model(User, email:"Joe@bar.com", id:1)
    @tailgate = assign(:tailgate, stub_model(Tailgate,
      :name => "Name",
      :user => @user,
      :team => @team
    ))
    @post = assign(:post, Post.new(tailgate:@tailgate))
    @current_user = assign(:current_user, @user)
    render
  end

  it "renders attributes in <p>" do
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Joe@bar.com/)
    rendered.should match(/Seahawks/)
  end

  it "renders partial" do
    view.should render_template(partial:"_media_slider")
  end
end
