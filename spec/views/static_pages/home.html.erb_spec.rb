require 'spec_helper'

describe "static_pages/home" do
  before do
    mock_geocoding!
    
    @social_info = stub_model(SocialInfo, hash_tags: "#goirish", not_tags:"")
    @sport = stub_model(Sport, id:1)
    @location = FactoryGirl.create(:location)
    @team = stub_model(Team, id:1, name:"Seahawks", social_info:@social_info, sport:@sport, slug:"seahawks", location:@location)
    @user = stub_model(User, email:"Joe@bar.com", id:1)
    @tailgate = assign(:tailgate, stub_model(Tailgate,
      :name => "Name",
      :user => @user,
      :team => @team,
      :topic_tags => "#goirish",
      :not_tags => ""
    ))
    @post = assign(:post, Post.new(tailgate_id:@tailgate.id))
    @venue = FactoryGirl.build(:venue)
    @watch_site = FactoryGirl.build(:watch_site, team:@team, venue:@venue)
    @localTeamWatchSites = assign(:localTeamWatchSites, [@watch_site])
    view.stub(:admin_signed_in?).and_return(false)
  end

  it "should have first run dialog when no user" do
    view.stub(:user_signed_in?).and_return(false)
    render
    rendered.should have_selector("div#myFirstRunModal")
  end
end
