require 'spec_helper'

describe UserTeamsController do
  login_user
  
  before do
    mock_geocoding!
    @user = FactoryGirl.create(:user)
    @team = FactoryGirl.create(:team)
  end

  def valid_attributes
    { team_id:@team.id }
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new UserTeam" do
        expect {
          post :create, {:user_team => valid_attributes, :user_id => @user.id}
        }.to change(UserTeam, :count).by(1)
      end

      it "assigns a newly created user_team as @user_team" do
        post :create, {:user_team => valid_attributes, :user_id => @user.id}
        assigns(:user_team).should be_a(UserTeam)
        assigns(:user_team).should be_persisted
      end

      it "redirects to the user" do
        post :create, {:user_team => valid_attributes, :user_id => @user.id}
        response.should redirect_to(user_path(@user))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user_team as @user_team" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserTeam.any_instance.stub(:save).and_return(false)
        post :create, {:user_team => {}, :user_id => @user.id}
        assigns(:user_team).should be_a_new(UserTeam)
      end

      it "redirects back to user" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserTeam.any_instance.stub(:save).and_return(false)
        post :create, {:user_team => {}, :user_id => @user.id}
        response.should redirect_to(user_path(@user))
      end
    end
  end


  describe "DELETE destroy" do
    it "destroys the requested user_team" do
      user_team = UserTeam.create! user_id:@user.id, team_id:@team.id
      expect {
        delete :destroy, {:id => user_team.to_param, :user_id => @user.id}
      }.to change(UserTeam, :count).by(-1)
    end

    it "redirects to the user" do
      user_team = UserTeam.create! user_id:@user.id, team_id:@team.id
      delete :destroy, {:id => user_team.to_param, :user_id => @user.id}
      response.should redirect_to(user_path(@user))
    end
  end

end
