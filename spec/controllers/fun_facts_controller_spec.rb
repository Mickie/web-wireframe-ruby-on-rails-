require 'spec_helper'

describe FunFactsController do
  login_admin
  
  def valid_attributes
    { content:"text", name:"text"}
  end

  describe "GET index" do
    it "assigns all fun_facts as @fun_facts" do
      fun_fact = FunFact.create! valid_attributes
      get :index, {}
      assigns(:fun_facts).should eq([fun_fact])
    end
  end

  describe "GET show" do
    it "assigns the requested fun_fact as @fun_fact" do
      fun_fact = FunFact.create! valid_attributes
      get :show, {:id => fun_fact.to_param}
      assigns(:fun_fact).should eq(fun_fact)
    end
  end

  describe "GET new" do
    it "assigns a new fun_fact as @fun_fact" do
      get :new, {}
      assigns(:fun_fact).should be_a_new(FunFact)
    end
  end

  describe "GET edit" do
    it "assigns the requested fun_fact as @fun_fact" do
      fun_fact = FunFact.create! valid_attributes
      get :edit, {:id => fun_fact.to_param}
      assigns(:fun_fact).should eq(fun_fact)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FunFact" do
        expect {
          post :create, {:fun_fact => valid_attributes}
        }.to change(FunFact, :count).by(1)
      end

      it "assigns a newly created fun_fact as @fun_fact" do
        post :create, {:fun_fact => valid_attributes}
        assigns(:fun_fact).should be_a(FunFact)
        assigns(:fun_fact).should be_persisted
      end

      it "redirects to the created fun_fact" do
        post :create, {:fun_fact => valid_attributes}
        response.should redirect_to(FunFact.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved fun_fact as @fun_fact" do
        # Trigger the behavior that occurs when invalid params are submitted
        FunFact.any_instance.stub(:save).and_return(false)
        post :create, {:fun_fact => {}}
        assigns(:fun_fact).should be_a_new(FunFact)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        FunFact.any_instance.stub(:save).and_return(false)
        post :create, {:fun_fact => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested fun_fact" do
        fun_fact = FunFact.create! valid_attributes
        # Assuming there are no other fun_facts in the database, this
        # specifies that the FunFact created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        FunFact.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => fun_fact.to_param, :fun_fact => {'these' => 'params'}}
      end

      it "assigns the requested fun_fact as @fun_fact" do
        fun_fact = FunFact.create! valid_attributes
        put :update, {:id => fun_fact.to_param, :fun_fact => valid_attributes}
        assigns(:fun_fact).should eq(fun_fact)
      end

      it "redirects to the fun_fact" do
        fun_fact = FunFact.create! valid_attributes
        put :update, {:id => fun_fact.to_param, :fun_fact => valid_attributes}
        response.should redirect_to(fun_fact)
      end
    end

    describe "with invalid params" do
      it "assigns the fun_fact as @fun_fact" do
        fun_fact = FunFact.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FunFact.any_instance.stub(:save).and_return(false)
        put :update, {:id => fun_fact.to_param, :fun_fact => {}}
        assigns(:fun_fact).should eq(fun_fact)
      end

      it "re-renders the 'edit' template" do
        fun_fact = FunFact.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FunFact.any_instance.stub(:save).and_return(false)
        put :update, {:id => fun_fact.to_param, :fun_fact => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested fun_fact" do
      fun_fact = FunFact.create! valid_attributes
      expect {
        delete :destroy, {:id => fun_fact.to_param}
      }.to change(FunFact, :count).by(-1)
    end

    it "redirects to the fun_facts list" do
      fun_fact = FunFact.create! valid_attributes
      delete :destroy, {:id => fun_fact.to_param}
      response.should redirect_to(fun_facts_url)
    end
  end

end
