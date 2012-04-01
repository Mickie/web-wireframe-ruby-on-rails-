require 'spec_helper'

describe "devise/registrations/new.html.erb" do
  
  before do
    view.should_receive(:resource).at_least(1).times.and_return(User.new)
    view.should_receive(:resource_name).at_least(1).times.and_return("user")
    view.should_receive(:devise_mapping).at_least(1).times.and_return(Devise.mappings[:user])
    view.should_receive(:resource_class).at_least(1).times.and_return(Devise.mappings[:user].to)
  end
  
  it "renders default look for completely new user" do
    render
    view.should render_template( partial: "_new_user" )
  end
  
  it "should show post twitter auth fields" do
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
                                            { uid: '12345', 
                                            info: { nickname: "foo@bar.com" }, 
                                            extra: { access_token: { token: "a token", secret: "a secret"} } 
                                            })
    
    session["devise.twitter_data"] = OmniAuth.config.mock_auth[:twitter]
    render
    
    view.should render_template( partial: "_twitter_authed_new_user" )
  end
  
end
