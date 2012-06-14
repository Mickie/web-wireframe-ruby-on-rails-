require 'spec_helper'

describe LeaguesController do
  login_admin
  
  before do
    @sport = FactoryGirl.create(:sport)
  end

  it "should have current_admin" do
    subject.current_admin.should_not be_nil
  end
  
  def valid_attributes
    { name:"NFL", sport_id: @sport.id }
  end

  describe "GET index" do
    before do
      @league = FactoryGirl.create(:league, visible:true)
      @invisibleLeague = FactoryGirl.create(:league, visible:false)
    end
    
    it "assigns all leagues as @leagues" do
      get :index, {}
      assigns(:leagues).should include(@league)
      assigns(:leagues).should include(@invisibleLeague)
    end
  end

  describe "GET show" do
    it "assigns the requested league as @league" do
      league = FactoryGirl.create(:league)
      get :show, {:id => league.to_param}
      assigns(:league).should eq(league)
    end
  end

  describe "GET new" do
    it "assigns a new league as @league" do
      get :new, {}
      assigns(:league).should be_a_new(League)
    end
  end

  describe "GET edit" do
    it "assigns the requested league as @league" do
      league = FactoryGirl.create(:league)
      get :edit, {:id => league.to_param}
      assigns(:league).should eq(league)
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
        league = FactoryGirl.create(:league)
        # Assuming there are no other leagues in the database, this
        # specifies that the League created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        League.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => league.to_param, :league => {'these' => 'params'}}
      end

      it "assigns the requested league as @league" do
        league = FactoryGirl.create(:league)
        put :update, {:id => league.to_param, :league => valid_attributes}
        assigns(:league).should eq(league)
      end

      it "redirects to the league" do
        league = FactoryGirl.create(:league)
        put :update, {:id => league.to_param, :league => valid_attributes}
        response.should redirect_to(league)
      end
    end

    describe "with invalid params" do
      it "assigns the league as @league" do
        league = FactoryGirl.create(:league)
        # Trigger the behavior that occurs when invalid params are submitted
        League.any_instance.stub(:save).and_return(false)
        put :update, {:id => league.to_param, :league => {}}
        assigns(:league).should eq(league)
      end

      it "re-renders the 'edit' template" do
        league = FactoryGirl.create(:league)
        # Trigger the behavior that occurs when invalid params are submitted
        League.any_instance.stub(:save).and_return(false)
        put :update, {:id => league.to_param, :league => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested league" do
      league = FactoryGirl.create(:league)
      expect {
        delete :destroy, {:id => league.to_param}
      }.to change(League, :count).by(-1)
    end

    it "redirects to the leagues list" do
      league = FactoryGirl.create(:league)
      delete :destroy, {:id => league.to_param}
      response.should redirect_to(leagues_url)
    end
  end

end
