require 'spec_helper'

describe "devise/registrations/new" do
  
  before do
    view.should_receive(:resource).at_least(1).times.and_return(User.new)
    view.should_receive(:resource_name).at_least(1).times.and_return("user")
  end
  
  it "renders default look for completely new user" do
    render
    view.should render_template( partial: "_new_user" )
    view.should_not render_template( partial: "_twitter_authed_new_user")
  end
  
  it "should show post twitter auth fields" do
    session["devise.twitter_data"] = twitter_auth
    render
    
    view.should_not render_template( partial: "_new_user")
    view.should render_template( partial: "_twitter_authed_new_user" )
    rendered.should have_selector("#user_twitter_user_id", value: '12345')
    rendered.should have_selector("#user_twitter_user_token", value: 'a token')
    rendered.should have_selector("#user_twitter_user_secret", value: 'a secret')
    rendered.should have_selector("#user_twitter_username", value: 'wilma')
  end

  it "should show post instagram auth fields" do
    session["devise.instagram_data"] = instagram_auth
    render
    
    view.should_not render_template( partial: "_new_user")
    view.should_not render_template( partial: "_twitter_authed_new_user")
    view.should render_template( partial: "_instagram_authed_new_user" )
    rendered.should have_selector("#user_instagram_user_id", value: '54321')
    rendered.should have_selector("#user_instagram_user_token", value: 'inst_token')
    rendered.should have_selector("#user_instagram_username", value: 'jimbob')
  end
  
end
