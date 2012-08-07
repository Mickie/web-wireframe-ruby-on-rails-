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
      
      it "handles attributes for brag when no brag id" do
        theBrag = Brag.new(content: "brag content")
        theAttributes = {
          brag_attributes: accessible_attributes(Brag, theBrag),
        }
        post :create, {:user_brag => theAttributes, :user_id => @user.id}
        assigns(:user_brag).brag.content.should eq("brag content")
      end

      it "handles attributes for brag when there is a brag" do
        theBrag = Brag.new(content: "brag content")
        theAttributes = {
          brag_id:@brag.id,
          brag_attributes: accessible_attributes(Brag, theBrag),
        }
        post :create, {:user_brag => theAttributes, :user_id => @user.id}
        assigns(:user_brag).brag_id.should eq(@brag.id)
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
    before do
      @user_brag = UserBrag.create! valid_attributes
      @user_brag.user_id = @user.id
      @user_brag.save
    end

    it "destroys the requested user_brag" do
      expect {
        delete :destroy, {:id => @user_brag.to_param, :user_id => @user.id}
      }.to change(UserBrag, :count).by(-1)
    end

    it "redirects to the user_brags list" do
      delete :destroy, {:id => @user_brag.to_param, :user_id => @user.id}
      response.should redirect_to(@user)
    end
  end

end
