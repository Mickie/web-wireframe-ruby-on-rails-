require 'spec_helper'

describe TopicsController do
  login_admin

  # This should return the minimal set of attributes required to create a valid
  # Topic. As you add validations to Topic, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { name:"foo", hash_tags:"#foo" }
  end

  describe "GET index" do
    it "assigns all topics as @topics" do
      topic = Topic.create! valid_attributes
      get :index, {}
      assigns(:topics).should eq([topic])
    end
  end

  describe "GET show" do
    it "assigns the requested topic as @topic" do
      topic = Topic.create! valid_attributes
      get :show, {:id => topic.to_param}
      assigns(:topic).should eq(topic)
    end
  end

  describe "GET new" do
    it "assigns a new topic as @topic" do
      get :new, {}
      assigns(:topic).should be_a_new(Topic)
    end
  end

  describe "GET edit" do
    it "assigns the requested topic as @topic" do
      topic = Topic.create! valid_attributes
      get :edit, {:id => topic.to_param}
      assigns(:topic).should eq(topic)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Topic" do
        expect {
          post :create, {:topic => valid_attributes}
        }.to change(Topic, :count).by(1)
      end

      it "assigns a newly created topic as @topic" do
        post :create, {:topic => valid_attributes}
        assigns(:topic).should be_a(Topic)
        assigns(:topic).should be_persisted
      end

      it "redirects to the created topic" do
        post :create, {:topic => valid_attributes}
        response.should redirect_to(Topic.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved topic as @topic" do
        # Trigger the behavior that occurs when invalid params are submitted
        Topic.any_instance.stub(:save).and_return(false)
        post :create, {:topic => {}}
        assigns(:topic).should be_a_new(Topic)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Topic.any_instance.stub(:save).and_return(false)
        post :create, {:topic => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested topic" do
        topic = Topic.create! valid_attributes
        # Assuming there are no other topics in the database, this
        # specifies that the Topic created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Topic.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => topic.to_param, :topic => {'these' => 'params'}}
      end

      it "assigns the requested topic as @topic" do
        topic = Topic.create! valid_attributes
        put :update, {:id => topic.to_param, :topic => valid_attributes}
        assigns(:topic).should eq(topic)
      end

      it "redirects to the topic" do
        topic = Topic.create! valid_attributes
        put :update, {:id => topic.to_param, :topic => valid_attributes}
        response.should redirect_to(topic)
      end
    end

    describe "with invalid params" do
      it "assigns the topic as @topic" do
        topic = Topic.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Topic.any_instance.stub(:save).and_return(false)
        put :update, {:id => topic.to_param, :topic => {}}
        assigns(:topic).should eq(topic)
      end

      it "re-renders the 'edit' template" do
        topic = Topic.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Topic.any_instance.stub(:save).and_return(false)
        put :update, {:id => topic.to_param, :topic => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested topic" do
      topic = Topic.create! valid_attributes
      expect {
        delete :destroy, {:id => topic.to_param}
      }.to change(Topic, :count).by(-1)
    end

    it "redirects to the topics list" do
      topic = Topic.create! valid_attributes
      delete :destroy, {:id => topic.to_param}
      response.should redirect_to(topics_url)
    end
  end

end
