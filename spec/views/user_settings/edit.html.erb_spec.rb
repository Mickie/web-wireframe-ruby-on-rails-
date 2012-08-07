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
    @brag = stub_model(Brag, content: "Brag")

    @iWasThereBrag = assign(:iWasThereBrag,
                            stub_model(IWasThereBrag, 
                                        user_id: 1,
                                        brag: @brag))

    @iWatchedBrag = assign(:iWatchedBrag,
                            stub_model(IWatchedBrag, 
                                       user_id: 1,
                                       brag: @brag))

    @iWishBrag = assign(:iWishBrag,
                          stub_model(IWishBrag, 
                                      user_id: 1,
                                      brag: @brag))
  end

  describe "partials" do

    it "should have rendered the add brag modal" do 
      render
      view.should render_template(partial:"_add_brag_modal")
    end

  end
end
