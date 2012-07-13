require 'spec_helper'

describe PostsController do
  
  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate)
  end

  def valid_attributes
    {
      content: "some content",
      user_id: @tailgate.user.id
    }
  end
  
  describe "GET index" do
    it "assigns all posts as @posts" do
      post = @tailgate.posts.create! valid_attributes
      
      get :index, { tailgate_id: @tailgate.id }
      assigns(:posts).should eq([post])
    end
  end

  describe "GET show" do
    it "assigns the requested post as @post" do
      post = @tailgate.posts.create! valid_attributes
      get :show, {:id => post.to_param, tailgate_id: @tailgate.id}
      assigns(:post).should eq(post)
    end
  end

  describe "GET new" do
    login_user
    before do
      get :new, { tailgate_id: @tailgate.id }      
    end
    it "assigns a new post as @post" do
      assigns(:post).should be_a_new(Post)
    end
    it "is linked to the tailgate" do
      assigns(:post).tailgate.should eq(@tailgate)
    end
    it "is linked to the current user" do
      assigns(:post).user.should eq(subject.current_user)
    end
  end

  describe "GET edit" do
    login_user

    it "assigns the requested post as @post" do
      post = @tailgate.posts.create! valid_attributes
      get :edit, {:id => post.to_param, tailgate_id: @tailgate.id}
      assigns(:post).should eq(post)
    end

    it "redirects to new if the logged in user is not the one who created it" do
      post = @tailgate.posts.create! valid_attributes
      get :edit, {:id => post.to_param, tailgate_id: @tailgate.id}
      response.should render_template("new")
    end

  end
  
  describe "POST up_vote" do
    login_user
    describe "with valid params" do
      it "changes the fan_score on existing post" do
        aPost = @tailgate.posts.create! valid_attributes
        aPost.fan_score.should eq(0)
        post "up_vote", { :id => aPost.to_param, tailgate_id: @tailgate.id }
        aPost.reload
        aPost.fan_score.should eq(1)
      end
    end
  end        

  describe "POST down_vote" do
    login_user
    describe "with valid params" do
      it "changes the fan_score on existing post" do
        aPost = @tailgate.posts.create! valid_attributes
        aPost.fan_score.should eq(0)
        post "down_vote", { :id => aPost.to_param, tailgate_id: @tailgate.id }
        aPost.reload
        aPost.fan_score.should eq(-1)
      end
    end
  end        
  

  describe "POST create" do
    login_user
    describe "with valid params" do
      it "creates a new Post" do
        expect {
          post :create, {:post => { content:"content" }, tailgate_id: @tailgate.id}
        }.to change(Post, :count).by(1)
      end

      it "assigns a newly created post as @post" do
        post :create, {:post => { content:"content" }, tailgate_id: @tailgate.id}
        assigns(:post).should be_a(Post)
        assigns(:post).should be_persisted
        assigns(:post).tailgate.should eq(@tailgate)
        assigns(:post).user.should eq(subject.current_user)
      end

      it "redirects to the tailgate for the post" do
        post :create, {:post => { content:"content" }, tailgate_id: @tailgate.id}
        response.should redirect_to(tailgate_path(@tailgate) )
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved post as @post" do
        # Trigger the behavior that occurs when invalid params are submitted
        Post.any_instance.stub(:save).and_return(false)
        post :create, {:post => {}, tailgate_id: @tailgate.id}
        assigns(:post).should be_a_new(Post)
        assigns(:post).user.should eq(subject.current_user)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Post.any_instance.stub(:save).and_return(false)
        post :create, {:post => {}, tailgate_id: @tailgate.id}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_user
    describe "with valid params" do
      it "updates the requested post" do
        post = @tailgate.posts.create! content:"some content", user_id:subject.current_user.id
        # Assuming there are no other posts in the database, this
        # specifies that the Post created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Post.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => post.to_param, :post => {'these' => 'params'}, tailgate_id: @tailgate.id}
      end

      it "assigns the requested post as @post" do
        post = @tailgate.posts.create! content:"some content", user_id:subject.current_user.id
        put :update, {:id => post.to_param, :post => valid_attributes, tailgate_id: @tailgate.id}
        assigns(:post).should eq(post)
      end

      it "redirects to the post" do
        post = @tailgate.posts.create! content:"some content", user_id:subject.current_user.id
        put :update, {:id => post.to_param, :post => valid_attributes, tailgate_id: @tailgate.id}
        response.should redirect_to(tailgate_post_path(@tailgate, post))
      end
    end

    describe "with invalid params" do
      it "redirects to new if the logged in user is not the one who created it" do
        post = @tailgate.posts.create! valid_attributes
        put :update, {:id => post.to_param, tailgate_id: @tailgate.id}
        response.should render_template("new")
      end
    
      it "assigns the post as @post" do
        post = @tailgate.posts.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Post.any_instance.stub(:save).and_return(false)
        put :update, {:id => post.to_param, :post => {}, tailgate_id: @tailgate.id}
        assigns(:post).should eq(post)
      end

      it "re-renders the 'edit' template" do
        post = @tailgate.posts.create! content:"some content", user_id:subject.current_user.id
        # Trigger the behavior that occurs when invalid params are submitted
        Post.any_instance.stub(:save).and_return(false)
        put :update, {:id => post.to_param, :post => {}, tailgate_id: @tailgate.id}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_user
    it "destroys the requested post" do
      post = @tailgate.posts.create! valid_attributes
      expect {
        delete :destroy, {:id => post.to_param, tailgate_id: @tailgate.id}
      }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      post = @tailgate.posts.create! valid_attributes
      delete :destroy, {:id => post.to_param, tailgate_id: @tailgate.id}
      response.should redirect_to(tailgate_posts_url(@tailgate))
    end
  end

  describe "getTailgateBitly" do
    it "should return cached value" do
      @tailgate.bitly = "http://bitly"
      subject.getTailgateBitly(@tailgate).should eq(@tailgate.bitly)
    end
    
    it "should call bitly to get value if not cached, then cache it" do
      theStubClient = double(Bitly::V3::Client)
      Bitly.stub(:new).and_return(theStubClient)
      theResponse = double(Bitly::V3::Url)
      theResponse.stub(:short_url).and_return("http://bit.ly/foo")
      
      theStubClient.should_receive(:shorten).and_return(theResponse)
      subject.getTailgateBitly(@tailgate).should eq("http://bit.ly/foo")
      @tailgate.bitly.should eq("http://bit.ly/foo") 
    end 
  end


end
