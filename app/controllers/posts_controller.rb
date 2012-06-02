class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy] 
  before_filter :load_tailgate

  def index
    @posts  = @tailgate.posts.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def show
    @post = @tailgate.posts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def new
    @post = @tailgate.posts.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  def edit
    @post = @tailgate.posts.find(params[:id])
  end

  def create
    @post = @tailgate.posts.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @tailgate, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @post = @tailgate.posts.find(params[:id])

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
    @post = @tailgate.posts.find(params[:id])

    if @post.tailgate == @tailgate
      @post.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to tailgate_posts_url(@tailgate) }
      format.json { head :no_content }
    end
  end
  
  private
    
    def load_tailgate
      @tailgate = Tailgate.find(params[:tailgate_id])
    end
end
