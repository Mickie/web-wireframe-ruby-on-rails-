require 'social_sender' 

class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :up_vote, :down_vote] 
  before_filter :load_tailgate
  

  def index
    thePage = params[:page] ? params[:page] : 1

    @posts  = @tailgate.posts.visible.page( thePage )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts.to_json(include: [ :user, :comments => { include: :user } ] ) }
      format.js
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
    @post = @tailgate.posts.new(user_id: current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  def edit
    @post = @tailgate.posts.find(params[:id])
    
    if ( @post.user.id != current_user.id )
      render action: "new", error: 'Cannot edit a post from a different user'
    end
  end

  def create
    @post = @tailgate.posts.new(params[:post])
    @post.user = current_user
    
    respond_to do |format|
      if @post.save
        
        if current_user.id != @tailgate.user_id
          UserMailer.delay.new_fanzone_post(@post.id) unless @tailgate.user.no_email_on_posts
        end
        
        SocialSender.new.delay.sharePost(@post.id)
        
        format.html { redirect_to @tailgate, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    @post = @tailgate.posts.find(params[:id])

    respond_to do |format|
      if @post.tailgate != @tailgate
        format.html { render action: "new", error: 'Cannot update post with a different tailgate' }
        format.json { render json: { error: 'Cannot update post with a different tailgate' }, status: :unprocessable_entity }
      elsif @post.user != current_user
        format.html { render action: "new", error: 'Cannot update post with a different user' }
        format.json { render json: { error: 'Cannot update post with a different user' }, status: :unprocessable_entity }
      elsif @post.update_attributes(params[:post])
        format.html { redirect_to tailgate_post_url(@tailgate, @post), notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def up_vote
    @post = @tailgate.posts.find(params[:id])
    @post.fan_score += 1

    theInitialVote = current_user.user_post_votes.find_by_post_id(@post.id)
    if theInitialVote
      theInitialVote.destroy
    end

    @vote = current_user.user_post_votes.create(post_id: @post.id)


    respond_to do |format|
      if @post.save
        format.html { redirect_to @tailgate, notice: 'Post was successfully up voted.' }
        format.json { head :no_content }
        format.js { render "vote" }
      else
        format.html { render action: "show" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js { render "vote" }
      end
    end
  end

  def down_vote
    @post = @tailgate.posts.find(params[:id])
    @post.fan_score -= 1
    
    theInitialVote = current_user.user_post_votes.find_by_post_id(@post.id)
    if theInitialVote
      theInitialVote.destroy
    end
    
    @vote = current_user.user_post_votes.create(post_id: @post.id, up_vote:false)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @tailgate, notice: 'Post was successfully down voted.' }
        format.json { head :no_content }
        format.js { render "vote" }
      else
        format.html { render action: "show" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js { render "vote" }
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
      format.js
    end
  end
    
  def load_tailgate
    @tailgate = Tailgate.find(params[:tailgate_id])
  end
end
