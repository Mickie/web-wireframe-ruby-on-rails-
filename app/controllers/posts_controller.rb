class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy] 

  def index
    @tailgate = Tailgate.find(params[:tailgate_id]) 
    @posts  = @tailgate.posts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def show
    @tailgate = Tailgate.find(params[:tailgate_id])
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def new
    @tailgate = Tailgate.find(params[:tailgate_id])
    @post = Post.new(tailgate:@tailgate)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  def edit
    @tailgate = Tailgate.find(params[:tailgate_id])
    @post = Post.find(params[:id])
  end

  def create
    @tailgate = Tailgate.find(params[:tailgate_id])
    @post = Post.new(params[:post])
    @post.tailgate = @tailgate 

    respond_to do |format|
      if @post.save
        format.html { redirect_to tailgate_post_url(@tailgate, @post), notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @tailgate = Tailgate.find(params[:tailgate_id])
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.tailgate != @tailgate
        format.html { render action: "new", error: 'Cannot update post with a different tailgate' }
        format.json { render json: { error: 'Cannot update post with a different tailgate' }, status: :unprocessable_entity }
      elsif @post.update_attributes(params[:post])
        format.html { redirect_to tailgate_post_url(@tailgate, @post), notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tailgate = Tailgate.find(params[:tailgate_id])
    @post = Post.find(params[:id])

    if @post.tailgate == @tailgate
      @post.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to tailgate_posts_url(@tailgate) }
      format.json { head :no_content }
    end
  end
end
