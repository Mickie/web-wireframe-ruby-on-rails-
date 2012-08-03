require 'spec_helper'

describe UserLocationsController do
  login_user

  before do
    @user = subject.current_user
  end

  def valid_attributes
    { location_query: "Seattle, WA" }
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new UserLocation" do
        expect {
          post :create, {:user_location => valid_attributes, :user_id => @user.id}
        }.to change(UserLocation, :count).by(1)
      end

      it "assigns a newly created user_location as @user_location" do
        post :create, {:user_location => valid_attributes, :user_id => @user.id}
        assigns(:user_location).should be_a(UserLocation)
        assigns(:user_location).should be_persisted
      end

      it "redirects to the user" do
        post :create, {:user_location => valid_attributes, :user_id => @user.id}
        response.should redirect_to(user_path(@user))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user_location as @user_location" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserLocation.any_instance.stub(:save).and_return(false)
        post :create, {:user_location => {}, :user_id => @user.id}
        assigns(:user_location).should be_a_new(UserLocation)
      end

      it "redirects back to user" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserLocation.any_instance.stub(:save).and_return(false)
        post :create, {:user_location => {}, :user_id => @user.id}
        response.should redirect_to(user_path(@user))
      end
    end
  end


  describe "DELETE destroy" do
    it "destroys the requested user_location" do
      user_location = @user.user_locations.create! valid_attributes
      expect {
        delete :destroy, {:id => user_location.to_param, :user_id => @user.id}
      }.to change(UserLocation, :count).by(-1)
    end

    it "redirects to the user" do
      user_location = @user.user_locations.create! valid_attributes
      delete :destroy, {:id => user_location.to_param, :user_id => @user.id}
      response.should redirect_to(user_path(@user))
    end
  end

end
