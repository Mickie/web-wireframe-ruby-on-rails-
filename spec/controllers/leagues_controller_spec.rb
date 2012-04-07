require 'spec_helper'

describe LeaguesController do
  login_admin

  it "should have current_admin" do
    subject.current_admin.should_not be_nil
  end
  
  def valid_attributes
    { name:"NFL" }
  end

  describe "GET index" do
    it "assigns all leagues as @leagues" do
      league = League.create! valid_attributes
      get :index, {}
      assigns(:leagues).should eq([league])
    end
  end

  describe "GET show" do
    it "assigns the requested league as @league" do
      league = League.create! valid_attributes
      get :show, {:id => league.to_param}
      assigns(:league).should eq(league)
    end
  end

  describe "GET new" do
    it "assigns a new league as @league" do
      get :new, {}
      assigns(:league).should be_a_new(League)
      assigns(:allSports).should be_a_kind_of(Array)
    end
  end

  describe "GET edit" do
    it "assigns the requested league as @league" do
      league = League.create! valid_attributes
      get :edit, {:id => league.to_param}
      assigns(:league).should eq(league)
      assigns(:allSports).should be_a_kind_of(Array)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new League" do
        expect {
          post :create, {:league => valid_attributes}
        }.to change(League, :count).by(1)
      end

      it "assigns a newly created league as @league" do
        post :create, {:league => valid_attributes}
        assigns(:league).should be_a(League)
        assigns(:league).should be_persisted
      end

      it "redirects to the created league" do
        post :create, {:league => valid_attributes}
        response.should redirect_to(League.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved league as @league" do
        # Trigger the behavior that occurs when invalid params are submitted
        League.any_instance.stub(:save).and_return(false)
        post :create, {:league => {}}
        assigns(:league).should be_a_new(League)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        League.any_instance.stub(:save).and_return(false)
        post :create, {:league => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested league" do
        league = League.create! valid_attributes
        # Assuming there are no other leagues in the database, this
        # specifies that the League created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        League.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => league.to_param, :league => {'these' => 'params'}}
      end

      it "assigns the requested league as @league" do
        league = League.create! valid_attributes
        put :update, {:id => league.to_param, :league => valid_attributes}
        assigns(:league).should eq(league)
      end

      it "redirects to the league" do
        league = League.create! valid_attributes
        put :update, {:id => league.to_param, :league => valid_attributes}
        response.should redirect_to(league)
      end
    end

    describe "with invalid params" do
      it "assigns the league as @league" do
        league = League.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        League.any_instance.stub(:save).and_return(false)
        put :update, {:id => league.to_param, :league => {}}
        assigns(:league).should eq(league)
      end

      it "re-renders the 'edit' template" do
        league = League.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        League.any_instance.stub(:save).and_return(false)
        put :update, {:id => league.to_param, :league => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested league" do
      league = League.create! valid_attributes
      expect {
        delete :destroy, {:id => league.to_param}
      }.to change(League, :count).by(-1)
    end

    it "redirects to the leagues list" do
      league = League.create! valid_attributes
      delete :destroy, {:id => league.to_param}
      response.should redirect_to(leagues_url)
    end
  end

end
