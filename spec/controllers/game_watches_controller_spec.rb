require 'spec_helper'

describe GameWatchesController do
  login_admin
  
  before do
    mock_geocoding!

    @event = FactoryGirl.create(:event)
    @venue = FactoryGirl.create(:venue)
    @user = FactoryGirl.create(:user)
  end

  def valid_attributes
    { 
      name:'Superbowl Party', 
      event_id:@event.id, 
      venue_id:@venue.id, 
      creator_id:@user.id,
    }
  end
  
  describe "GET index" do
    it "assigns all game_watches as @game_watches" do
      game_watch = GameWatch.create! valid_attributes
      get :index, {}
      assigns(:game_watches).should eq([game_watch])
    end
  end

  describe "GET show" do
    it "assigns the requested game_watch as @game_watch" do
      game_watch = GameWatch.create! valid_attributes
      get :show, {:id => game_watch.to_param}
      assigns(:game_watch).should eq(game_watch)
    end
  end

  describe "GET new" do
    it "assigns a new game_watch as @game_watch" do
      get :new, {}
      assigns(:game_watch).should be_a_new(GameWatch)
    end
  end

  describe "GET edit" do
    it "assigns the requested game_watch as @game_watch" do
      game_watch = GameWatch.create! valid_attributes
      get :edit, {:id => game_watch.to_param}
      assigns(:game_watch).should eq(game_watch)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new GameWatch" do
        expect {
          post :create, {:game_watch => valid_attributes}
        }.to change(GameWatch, :count).by(1)
      end

      it "assigns a newly created game_watch as @game_watch" do
        post :create, {:game_watch => valid_attributes}
        assigns(:game_watch).should be_a(GameWatch)
        assigns(:game_watch).should be_persisted
      end

      it "redirects to the created game_watch" do
        post :create, {:game_watch => valid_attributes}
        response.should redirect_to(GameWatch.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved game_watch as @game_watch" do
        # Trigger the behavior that occurs when invalid params are submitted
        GameWatch.any_instance.stub(:save).and_return(false)
        post :create, {:game_watch => {}}
        assigns(:game_watch).should be_a_new(GameWatch)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        GameWatch.any_instance.stub(:save).and_return(false)
        post :create, {:game_watch => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested game_watch" do
        game_watch = GameWatch.create! valid_attributes
        # Assuming there are no other game_watches in the database, this
        # specifies that the GameWatch created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        GameWatch.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => game_watch.to_param, :game_watch => {'these' => 'params'}}
      end

      it "assigns the requested game_watch as @game_watch" do
        game_watch = GameWatch.create! valid_attributes
        put :update, {:id => game_watch.to_param, :game_watch => valid_attributes}
        assigns(:game_watch).should eq(game_watch)
      end

      it "redirects to the game_watch" do
        game_watch = GameWatch.create! valid_attributes
        put :update, {:id => game_watch.to_param, :game_watch => valid_attributes}
        response.should redirect_to(game_watch)
      end
    end

    describe "with invalid params" do
      it "assigns the game_watch as @game_watch" do
        game_watch = GameWatch.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        GameWatch.any_instance.stub(:save).and_return(false)
        put :update, {:id => game_watch.to_param, :game_watch => {}}
        assigns(:game_watch).should eq(game_watch)
      end

      it "re-renders the 'edit' template" do
        game_watch = GameWatch.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        GameWatch.any_instance.stub(:save).and_return(false)
        put :update, {:id => game_watch.to_param, :game_watch => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested game_watch" do
      game_watch = GameWatch.create! valid_attributes
      expect {
        delete :destroy, {:id => game_watch.to_param}
      }.to change(GameWatch, :count).by(-1)
    end

    it "redirects to the game_watches list" do
      game_watch = GameWatch.create! valid_attributes
      delete :destroy, {:id => game_watch.to_param}
      response.should redirect_to(game_watches_url)
    end
  end

end
