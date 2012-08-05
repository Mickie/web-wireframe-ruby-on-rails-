require 'spec_helper'

describe CommentsController do

  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate)
    @post = @tailgate.posts.create(user_id:@tailgate.user.id, content:"post content")
  end

  def valid_attributes
    {
      content: "content",
      user_id: @post.user_id
    }
  end
  
  describe "GET index" do
    it "assigns all comments as @comments" do
      comment = @post.comments.create! valid_attributes
      get :index, { post_id: @post.id, tailgate_id: @tailgate.id }
      assigns(:comments).should eq([comment])
    end
  end

  describe "GET show" do
    it "assigns the requested comment as @comment" do
      comment = @post.comments.create! valid_attributes
      get :show, { id: comment.to_param, post_id: @post.id, tailgate_id: @tailgate.id }
      assigns(:comment).should eq(comment)
    end
  end

  describe "GET new" do
    login_user
    it "assigns a new comment as @comment" do
      get :new, { post_id: @post.id, tailgate_id: @tailgate.id }
      assigns(:comment).should be_a_new(Comment)
      assigns(:comment).user.should eq(subject.current_user)
    end
  end

  describe "GET edit" do
    login_user
    it "assigns the requested comment as @comment" do
      comment = @post.comments.create! valid_attributes
      get :edit, { id: comment.to_param, post_id: @post.id, tailgate_id: @tailgate.id }
      assigns(:comment).should eq(comment)
    end
  end

  describe "POST create" do
    login_user
    describe "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, { comment: valid_attributes, post_id: @post.id, tailgate_id: @tailgate.id }
        }.to change(Comment, :count).by(1)
      end
      
      describe "with the correct stuff" do
        before do
          post :create, { comment: valid_attributes, post_id: @post.id, tailgate_id: @tailgate.id }
        end
  
        it "assigns a newly created comment as @comment" do
          assigns(:comment).should be_a(Comment)
          assigns(:comment).should be_persisted
        end
  
        it "redirects to the tailgate" do
          response.should redirect_to(@tailgate)
        end
        
        it "associates the signed in user with the comment" do
          assigns(:comment).user.should eq(subject.current_user)          
        end
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, { comment: {}, post_id: @post.id, tailgate_id: @tailgate.id }
        assigns(:comment).should be_a_new(Comment)
      end

      it "redirects back to tailgate" do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, { comment: {}, post_id: @post.id, tailgate_id: @tailgate.id }
        response.should redirect_to(@tailgate)
      end
    end
  end

  describe "PUT update" do
    login_user
    describe "with valid params" do
      it "updates the requested comment" do
        comment = @post.comments.create! valid_attributes
        # Assuming there are no other comments in the database, this
        # specifies that the Comment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Comment.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => comment.to_param, :comment => {'these' => 'params'}, post_id: @post.id, tailgate_id: @tailgate.id }
      end

      it "assigns the requested comment as @comment" do
        comment = @post.comments.create! valid_attributes
        put :update, {:id => comment.to_param, :comment => valid_attributes, post_id: @post.id, tailgate_id: @tailgate.id }
        assigns(:comment).should eq(comment)
      end

      it "redirects to the tailgate" do
        comment = @post.comments.create! valid_attributes
        put :update, {:id => comment.to_param, :comment => valid_attributes, post_id: @post.id, tailgate_id: @tailgate.id }
        response.should redirect_to(@tailgate)
      end
    end

    describe "with invalid params" do
      it "assigns the comment as @comment" do
        comment = @post.comments.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        put :update, {:id => comment.to_param, :comment => {}, post_id: @post.id, tailgate_id: @tailgate.id }
        assigns(:comment).should eq(comment)
      end

      it "redirects to the tailgate" do
        comment = @post.comments.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        put :update, {:id => comment.to_param, :comment => {}, post_id: @post.id, tailgate_id: @tailgate.id }
        response.should redirect_to(@tailgate)
      end
    end
  end

  describe "PUT up_vote" do
    login_user
    describe "with valid params" do
      it "changes the fan_score on existing comment" do
        aComment = @post.comments.create! valid_attributes
        aComment.fan_score.should eq(0)
        put "up_vote", { :id => aComment.to_param, post_id: @post.id, tailgate_id: @tailgate.id }
        aComment.reload
        aComment.fan_score.should eq(1)
      end
    end
  end        

  describe "PUT down_vote" do
    login_user
    describe "with valid params" do
      it "changes the fan_score on existing post" do
        aComment = @post.comments.create! valid_attributes
        aComment.fan_score.should eq(0)
        put "down_vote", { :id => aComment.to_param, post_id: @post.id, tailgate_id: @tailgate.id }
        aComment.reload
        aComment.fan_score.should eq(-1)
      end
    end
  end        


  describe "DELETE destroy" do
    login_user
    it "destroys the requested comment" do
      comment = @post.comments.create! valid_attributes
      expect {
        delete :destroy, {:id => comment.to_param, post_id: @post.id, tailgate_id: @tailgate.id }
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the tailgate" do
      comment = @post.comments.create! valid_attributes
      delete :destroy, {:id => comment.to_param, post_id: @post.id, tailgate_id: @tailgate.id }
      response.should redirect_to(@tailgate)
    end
  end

  describe "send comment notifications" do
    
    before do
      @second_user = FactoryGirl.create( :user )
      @third_user = FactoryGirl.create( :user )
      @comment_by_post_user = @post.comments.create! valid_attributes
      @comment_by_second_user  = @post.comments.create!( user_id: @second_user.id, content: "I am second user")
      @comment_by_third_user  = @post.comments.create!( user_id: @third_user.id, content: "I am third user")
      @second_comment_by_second_user  = @post.comments.create!( user_id: @second_user.id, content: "I am second user's second comment")
      @theMailerDouble = double("UserMailer")
    end

    it "sends new comment notification to poster" do
      UserMailer.stub(:delay).and_return(@theMailerDouble)
      @theMailerDouble.should_receive(:new_post_comment).once.with( @second_comment_by_second_user.id )
      @theMailerDouble.should_receive(:also_commented).once
      subject.sendCommentNotifications( @second_comment_by_second_user )
    end

    it "doesn't send new comment notification if the commenter was original poster" do
      UserMailer.stub(:delay).and_return(@theMailerDouble)
      @theMailerDouble.should_not_receive(:new_post_comment)
      @theMailerDouble.should_receive(:also_commented).twice
      subject.sendCommentNotifications( @comment_by_post_user )
    end
    
    it "sends also commented notification to correct group" do
      fourthUser = FactoryGirl.create( :user )
      @post.comments.create!( user_id: fourthUser.id, content: "I am fourth user, comment 1")
      @post.comments.create!( user_id: fourthUser.id, content: "I am fourth user, comment 2")
      @post.comments.create!( user_id: fourthUser.id, content: "I am fourth user, comment 3")
      @post.comments.create!( user_id: fourthUser.id, content: "I am fourth user, comment 4")
      UserMailer.stub(:delay).and_return(@theMailerDouble)
      @theMailerDouble.should_receive(:also_commented).once.with( @comment_by_post_user.id, @second_user.id)
      @theMailerDouble.should_receive(:also_commented).once.with( @comment_by_post_user.id, @third_user.id)
      @theMailerDouble.should_receive(:also_commented).once.with( @comment_by_post_user.id, fourthUser.id)
      @theMailerDouble.should_not_receive(:also_commented).with( @comment_by_post_user.id, @post.user.id)
      
      subject.sendCommentNotifications( @comment_by_post_user )
    end

  end
end
