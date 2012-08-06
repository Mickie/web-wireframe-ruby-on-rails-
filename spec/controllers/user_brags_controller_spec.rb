require 'spec_helper'

describe UserBragsController do
  login_user 
  

  before do
    @user = subject.current_user
    @brag = FactoryGirl.create(:brag)
  end

  def valid_attributes
    {brag_id: @brag.id}
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new UserBrag" do
        expect {
          post :create, {:user_brag => valid_attributes, :user_id => @user.id}
        }.to change(UserBrag, :count).by(1)
      end

      it "assigns a newly created user_brag as @user_brag" do
        post :create, {:user_brag => valid_attributes, :user_id => @user.id}
        assigns(:user_brag).should be_a(UserBrag)
        assigns(:user_brag).should be_persisted
      end

      it "redirects to the created user_brag" do
        post :create, {:user_brag => valid_attributes, :user_id => @user.id}
        response.should redirect_to(@user)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user_brag as @user_brag" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserBrag.any_instance.stub(:save).and_return(false)
        post :create, {:user_brag => {}, :user_id => @user.id}
        assigns(:user_brag).should be_a_new(UserBrag)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserBrag.any_instance.stub(:save).and_return(false)
        post :create, {:user_brag => {}, :user_id => @user.id}
        response.should redirect_to(@user)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user_brag" do
      user_brag = @user.user_brags.create! valid_attributes
      expect {
        delete :destroy, {:id => user_brag.to_param, :user_id => @user.id}
      }.to change(UserBrag, :count).by(-1)
    end

    it "redirects to the user_brags list" do
      user_brag = @user.user_brags.create! valid_attributes
      delete :destroy, {:id => user_brag.to_param, :user_id => @user.id}
      response.should redirect_to(@user)
    end
  end

end
