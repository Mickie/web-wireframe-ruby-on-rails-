require 'spec_helper'

describe EventPostsController do

  before do
    mock_geocoding!
    @event = FactoryGirl.create(:event)
    @event.save
    @tailgate = FactoryGirl.create(:tailgate, team_id: @event.home_team.id, official:true )
  end


  def valid_attributes
    {
      home_flag: true,
      visiting_flag: false
    }
  end
  
  def post_fields
    {
      event_id: @event.id,
      event_post: valid_attributes,
      post: { content: "test" }
    }
  end
  
  

  describe "GET index" do
    it "assigns all event_posts as @event_posts" do
      event_post = @event.event_posts.create! valid_attributes
      get :index, { event_id: @event.id }
      assigns(:event_posts).should eq([event_post])
    end
  end

  describe "GET show" do
    it "assigns the requested event_post as @event_post" do
      event_post = @event.event_posts.create! valid_attributes
      get :show, {:id => event_post.to_param, event_id: @event.id }
      assigns(:event_post).should eq(event_post)
    end
  end

  describe "GET new" do
    login_user
    it "assigns a new event_post as @event_post" do
      get :new, { event_id: @event.id }
      assigns(:event_post).should be_a_new(EventPost)
    end
  end

  describe "GET edit" do
    login_user
    it "assigns the requested event_post as @event_post" do
      event_post = @event.event_posts.create! valid_attributes
      get :edit, {:id => event_post.to_param, event_id: @event.id }
      assigns(:event_post).should eq(event_post)
    end
  end

  describe "POST create" do
    login_user
    
    describe "with valid params" do
      it "creates a new EventPost" do
        expect {
          post :create, post_fields
        }.to change(EventPost, :count).by(1)
      end

      it "assigns a newly created event_post as @event_post" do
        post :create, post_fields
        assigns(:event_post).should be_a(EventPost)
        assigns(:event_post).should be_persisted
      end

      it "redirects to the event" do
        post :create, post_fields
        response.should redirect_to(@event)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event_post as @event_post" do
        # Trigger the behavior that occurs when invalid params are submitted
        EventPost.any_instance.stub(:save).and_return(false)
        post :create, {:event_post => {}, event_id: @event.id }
        assigns(:event_post).should be_a_new(EventPost)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        EventPost.any_instance.stub(:save).and_return(false)
        post :create, {:event_post => {}, event_id: @event.id }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_user
    describe "with valid params" do
      it "updates the requested event_post" do
        event_post = @event.event_posts.create! valid_attributes
        # Assuming there are no other event_posts in the database, this
        # specifies that the EventPost created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        EventPost.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => event_post.to_param, :event_post => {'these' => 'params'}, event_id: @event.id }
      end

      it "assigns the requested event_post as @event_post" do
        event_post = @event.event_posts.create! valid_attributes
        put :update, {:id => event_post.to_param, :event_post => valid_attributes,  event_id: @event.id, post:{content:"test"} }
        assigns(:event_post).should eq(event_post)
      end

      it "redirects to the event" do
        event_post = @event.event_posts.create! valid_attributes
        put :update, {:id => event_post.to_param, :event_post => valid_attributes, event_id: @event.id, post:{content:"test"} }
        response.should redirect_to(@event)
      end
    end

    describe "with invalid params" do
      it "assigns the event_post as @event_post" do
        event_post = @event.event_posts.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        EventPost.any_instance.stub(:save).and_return(false)
        put :update, {:id => event_post.to_param, :event_post => {}, event_id: @event.id, post:{content:"test"} }
        assigns(:event_post).should eq(event_post)
      end

      it "re-renders the 'edit' template" do
        event_post = @event.event_posts.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        EventPost.any_instance.stub(:save).and_return(false)
        put :update, {:id => event_post.to_param, :event_post => {}, event_id: @event.id, post:{content:"test"} }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_user
    it "destroys the requested event_post" do
      event_post = @event.event_posts.create! valid_attributes
      expect {
        delete :destroy, {:id => event_post.to_param, event_id: @event.id }
      }.to change(EventPost, :count).by(-1)
    end

    it "redirects to the event" do
      event_post = @event.event_posts.create! valid_attributes
      delete :destroy, {:id => event_post.to_param, event_id: @event.id }
      response.should redirect_to(@event)
    end
  end

end
