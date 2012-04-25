require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :email => "joe@foo.com"
    ))
    @user_team = assign(:user_team, stub_model(UserTeam,
      :user_id => 1
    ))
  end

  it "should include the email" do
    render
    rendered.should match(/joe@foo.com/)
  end 
  
  describe "partials" do
    
    it "should show team picker for new user" do
      render
      view.should render_template(partial:"_team_picker")
      view.should_not render_template(partial:"_game_picker") 
    end
    
    it "should show game picker for existing user" do
      mock_geocoding!
      @user = assign(:user, stub_model(User,
        email: "bar@foo.com",
        teams: [FactoryGirl.create(:team)]
      ))
      render
      view.should_not render_template(partial:"_team_picker")
      view.should render_template(partial:"_game_picker") 
    end
  end
end
