
class CommentsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :up_vote, :down_vote] 
  before_filter :load_post
  
  # GET /comments
  # GET /comments.json
  def index
    @comments = @post.comments.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = @post.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = @post.comments.new
    @comment.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = @post.comments.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @post.comments.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        
        if current_user.id != @post.user_id
          UserMailer.delay.new_post_comment(@comment.id) unless @post.user.no_email_on_comments
        end
        
        @post.comments.each do |aComment|
          if ( aComment.user.id != current_user.id && aComment.user.id != @post.user_id)
            UserMailer.delay.also_commented(@comment.id, aComment.user.id) unless aComment.user.no_email_on_comments
          end
        end
              
        format.html { redirect_to @post.tailgate, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
        format.js
      else
        format.html { redirect_to @post.tailgate, error: 'Unable to create comment'}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = @post.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @post.tailgate, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @post.tailgate, error: 'Unable to update comment' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def up_vote
    @comment = @post.comments.find(params[:id])
    @comment.fan_score += 1

    theInitialVote = current_user.user_comment_votes.find_by_comment_id(@comment.id)
    if theInitialVote
      theInitialVote.destroy
    end

    @vote = current_user.user_comment_votes.create(comment_id: @comment.id)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post.tailgate, notice: 'Comment was successfully up voted.' }
        format.json { head :no_content }
        format.js { render "vote" }
      else
        format.html { render action: "show" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { render "vote" }
      end
    end
  end

  def down_vote
    @comment = @post.comments.find(params[:id])
    @comment.fan_score -= 1

    theInitialVote = current_user.user_comment_votes.find_by_comment_id(@comment.id)
    if theInitialVote
      theInitialVote.destroy
    end

    @vote = current_user.user_comment_votes.create(comment_id: @comment.id, up_vote:false)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post.tailgate, notice: 'Post was successfully down voted.' }
        format.json { head :no_content }
        format.js { render "vote" }
      else
        format.html { render action: "show" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { render "vote" }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to tailgate_path(@post.tailgate) }
      format.json { head :no_content }
      format.js
    end
  end
  
  private
  
    def load_post
      @post = Post.find(params[:post_id])
    end
end
