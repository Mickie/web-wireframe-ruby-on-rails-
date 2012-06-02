
class CommentsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy] 
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
        format.html { redirect_to @post.tailgate, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to @post.tailgate, error: 'Unable to create comment'}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
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

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to tailgate_path(@post.tailgate) }
      format.json { head :no_content }
    end
  end
  
  private
  
    def load_post
      @post = Post.find(params[:post_id])
    end
end
