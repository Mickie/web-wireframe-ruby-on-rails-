require 'spec_helper'
 
describe UserSettingsController do
  login_user
  
  before do
    subject.current_user.save
  end

  def valid_attributes
    { 
    }
  end
  

  describe "GET edit" do
    it "assigns the current user as @user" do
      get :edit
      assigns(:user).should eq(subject.current_user)
    end

    it "assigns some brags" do
      get :edit
      assigns(:iWasThereBrag).should be_a_new(IWasThereBrag)
      assigns(:iWasThereBrag).brag.should be_a_new(Brag)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the current user" do
        subject.current_user.should_receive(:update_without_password).with({'these' => 'params'})
        put :update, {:id => subject.current_user.to_param, :user => {'these' => 'params'}}
      end

      it "assigns the current user as @user" do
        put :update, {:id => subject.current_user.to_param, :user => valid_attributes}
        assigns(:user).should eq(subject.current_user)
      end

      it "redirects to the user" do
        put :update, {:id => subject.current_user.to_param, :user => valid_attributes}
        response.should redirect_to(subject.current_user)
      end
    end

    describe "with invalid params" do
      it "assigns the current user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:update_without_password).and_return(false)
        put :update, {:id => subject.current_user.to_param, :user => {}}
        assigns(:user).should eq(subject.current_user)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:update_without_password).and_return(false)
        put :update, {:id => subject.current_user.to_param, :user => {}}
        response.should render_template("edit")
      end
    end
  end

end
