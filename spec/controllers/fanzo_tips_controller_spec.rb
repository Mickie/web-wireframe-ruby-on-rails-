require 'spec_helper'

describe FanzoTipsController do
  login_admin

  def valid_attributes
    { content:"text", name:"text"}
  end

  describe "GET index" do
    it "assigns all fanzo_tips as @fanzo_tips" do
      fanzo_tip = FanzoTip.create! valid_attributes
      get :index, {}
      assigns(:fanzo_tips).should include(fanzo_tip)
    end
  end

  describe "GET show" do
    it "assigns the requested fanzo_tip as @fanzo_tip" do
      fanzo_tip = FanzoTip.create! valid_attributes
      get :show, {:id => fanzo_tip.to_param}
      assigns(:fanzo_tip).should eq(fanzo_tip)
    end
  end

  describe "GET new" do
    it "assigns a new fanzo_tip as @fanzo_tip" do
      get :new, {}
      assigns(:fanzo_tip).should be_a_new(FanzoTip)
    end
  end

  describe "GET edit" do
    it "assigns the requested fanzo_tip as @fanzo_tip" do
      fanzo_tip = FanzoTip.create! valid_attributes
      get :edit, {:id => fanzo_tip.to_param}
      assigns(:fanzo_tip).should eq(fanzo_tip)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FanzoTip" do
        expect {
          post :create, {:fanzo_tip => valid_attributes}
        }.to change(FanzoTip, :count).by(1)
      end

      it "assigns a newly created fanzo_tip as @fanzo_tip" do
        post :create, {:fanzo_tip => valid_attributes}
        assigns(:fanzo_tip).should be_a(FanzoTip)
        assigns(:fanzo_tip).should be_persisted
      end

      it "redirects to the created fanzo_tip" do
        post :create, {:fanzo_tip => valid_attributes}
        response.should redirect_to(FanzoTip.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved fanzo_tip as @fanzo_tip" do
        # Trigger the behavior that occurs when invalid params are submitted
        FanzoTip.any_instance.stub(:save).and_return(false)
        post :create, {:fanzo_tip => {}}
        assigns(:fanzo_tip).should be_a_new(FanzoTip)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        FanzoTip.any_instance.stub(:save).and_return(false)
        post :create, {:fanzo_tip => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested fanzo_tip" do
        fanzo_tip = FanzoTip.create! valid_attributes
        # Assuming there are no other fanzo_tips in the database, this
        # specifies that the FanzoTip created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        FanzoTip.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => fanzo_tip.to_param, :fanzo_tip => {'these' => 'params'}}
      end

      it "assigns the requested fanzo_tip as @fanzo_tip" do
        fanzo_tip = FanzoTip.create! valid_attributes
        put :update, {:id => fanzo_tip.to_param, :fanzo_tip => valid_attributes}
        assigns(:fanzo_tip).should eq(fanzo_tip)
      end

      it "redirects to the fanzo_tip" do
        fanzo_tip = FanzoTip.create! valid_attributes
        put :update, {:id => fanzo_tip.to_param, :fanzo_tip => valid_attributes}
        response.should redirect_to(fanzo_tip)
      end
    end

    describe "with invalid params" do
      it "assigns the fanzo_tip as @fanzo_tip" do
        fanzo_tip = FanzoTip.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FanzoTip.any_instance.stub(:save).and_return(false)
        put :update, {:id => fanzo_tip.to_param, :fanzo_tip => {}}
        assigns(:fanzo_tip).should eq(fanzo_tip)
      end

      it "re-renders the 'edit' template" do
        fanzo_tip = FanzoTip.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FanzoTip.any_instance.stub(:save).and_return(false)
        put :update, {:id => fanzo_tip.to_param, :fanzo_tip => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested fanzo_tip" do
      fanzo_tip = FanzoTip.create! valid_attributes
      expect {
        delete :destroy, {:id => fanzo_tip.to_param}
      }.to change(FanzoTip, :count).by(-1)
    end

    it "redirects to the fanzo_tips list" do
      fanzo_tip = FanzoTip.create! valid_attributes
      delete :destroy, {:id => fanzo_tip.to_param}
      response.should redirect_to(fanzo_tips_url)
    end
  end

end
