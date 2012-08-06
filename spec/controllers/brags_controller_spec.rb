require 'spec_helper'

describe BragsController do

  def valid_attributes
    { content: "I am so cool" } 
  end

  describe "GET index" do
    login_admin
    it "assigns all brags as @brags" do
      brag = Brag.create! valid_attributes
      get :index, {}
      assigns(:brags).should eq([brag])
    end
  end

  describe "GET show" do
    login_admin
    it "assigns the requested brag as @brag" do
      brag = Brag.create! valid_attributes
      get :show, {:id => brag.to_param}
      assigns(:brag).should eq(brag)
    end
  end

  describe "GET new" do
    login_admin
    it "assigns a new brag as @brag" do
      get :new, {}
      assigns(:brag).should be_a_new(Brag)
    end
  end

  describe "GET edit" do
    login_admin
    it "assigns the requested brag as @brag" do
      brag = Brag.create! valid_attributes
      get :edit, {:id => brag.to_param}
      assigns(:brag).should eq(brag)
    end
  end

  describe "POST create" do
    login_admin
    describe "with valid params" do
      it "creates a new Brag" do
        expect {
          post :create, {:brag => valid_attributes}
        }.to change(Brag, :count).by(1)
      end

      it "assigns a newly created brag as @brag" do
        post :create, {:brag => valid_attributes}
        assigns(:brag).should be_a(Brag)
        assigns(:brag).should be_persisted
      end

      it "redirects to the created brag" do
        post :create, {:brag => valid_attributes}
        response.should redirect_to(Brag.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved brag as @brag" do
        # Trigger the behavior that occurs when invalid params are submitted
        Brag.any_instance.stub(:save).and_return(false)
        post :create, {:brag => {}}
        assigns(:brag).should be_a_new(Brag)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Brag.any_instance.stub(:save).and_return(false)
        post :create, {:brag => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_admin
    describe "with valid params" do
      it "updates the requested brag" do
        brag = Brag.create! valid_attributes
        # Assuming there are no other brags in the database, this
        # specifies that the Brag created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Brag.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => brag.to_param, :brag => {'these' => 'params'}}
      end

      it "assigns the requested brag as @brag" do
        brag = Brag.create! valid_attributes
        put :update, {:id => brag.to_param, :brag => valid_attributes}
        assigns(:brag).should eq(brag)
      end

      it "redirects to the brag" do
        brag = Brag.create! valid_attributes
        put :update, {:id => brag.to_param, :brag => valid_attributes}
        response.should redirect_to(brag)
      end
    end

    describe "with invalid params" do
      it "assigns the brag as @brag" do
        brag = Brag.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Brag.any_instance.stub(:save).and_return(false)
        put :update, {:id => brag.to_param, :brag => {}}
        assigns(:brag).should eq(brag)
      end

      it "re-renders the 'edit' template" do
        brag = Brag.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Brag.any_instance.stub(:save).and_return(false)
        put :update, {:id => brag.to_param, :brag => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "destroys the requested brag" do
      brag = Brag.create! valid_attributes
      expect {
        delete :destroy, {:id => brag.to_param}
      }.to change(Brag, :count).by(-1)
    end

    it "redirects to the brags list" do
      brag = Brag.create! valid_attributes
      delete :destroy, {:id => brag.to_param}
      response.should redirect_to(brags_url)
    end
  end

end
