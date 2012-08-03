require 'spec_helper'

describe "user_settings/edit" do 
  before(:each) do
    mock_geocoding!

    @user = assign( :user, 
                    stub_model(User,
                               :email => "joe@foo.com"
                    ))
    @user_team = assign(:user_team, 
                        stub_model(UserTeam,
                                  :user_id => 1
                        ))

    @user_location = assign(:user_location,
                            stub_model(UserLocation,
                                      :user_id => 1
                            ))

  end

  describe "partials" do

    it "should show team picker for new user" do 
      render
      view.should render_template(partial:"_team_picker")
    end

  end
end
