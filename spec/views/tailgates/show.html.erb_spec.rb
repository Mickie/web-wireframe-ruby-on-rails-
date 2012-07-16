require 'spec_helper'

describe "tailgates/show" do
  before(:each) do
    @social_info = stub_model(SocialInfo, hash_tags: "#goirish", not_tags:"")
    @sport = stub_model(Sport, id:1)
    @team = stub_model(Team, id:1, name:"Seahawks", social_info:@social_info, sport:@sport, slug:"seahawks")
    @user = stub_model(User, email:"Joe@bar.com", id:1)
    @tailgate = assign(:tailgate, stub_model(Tailgate,
      :name => "Name",
      :user => @user,
      :team => @team,
      :topic_tags => "#goirish",
      :not_tags => ""
    ))
    @post = assign(:post, Post.new(tailgate_id:@tailgate.id))
    view.stub(:user_signed_in?).and_return(false);
    view.stub(:admin_signed_in?).and_return(false);
    
    @venue = FactoryGirl.build(:venue)
    @watch_site = FactoryGirl.build(:watch_site, team:@team, venue:@venue)
    @localTeamWatchSites = assign(:localTeamWatchSites, [@watch_site])
    render
  end

  it "renders attributes in <p>" do
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Joe@bar.com/)
  end

  it "renders partial" do
    view.should render_template(partial:"_media_slider")
  end
end
