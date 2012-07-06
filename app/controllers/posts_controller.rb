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
    
    if (@post.valid?)
      sendToSocialNetworks(@post)
    end

    respond_to do |format|
      if @post.save
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
  
    def sendToSocialNetworks( aPost )
      if (aPost.twitter_flag)
        sendToTwitter(aPost)
      end
      if (aPost.facebook_flag)
        sendToFacebook(aPost)
      end
    end
    
    def sendToTwitter( aPost )
      if (current_user.twitter_user_token.empty? || current_user.twitter_user_secret.empty?)
        Rails.logger.warn "Error posting to twitter: user not connected"
        return
      end
      
      theClient = Twitter::Client.new( 
        oauth_token: current_user.twitter_user_token,
        oauth_token_secret: current_user.twitter_user_secret
      )

      begin
        if aPost.twitter_retweet_id && !aPost.twitter_retweet_id.empty?
          theStatus = theClient.retweet(aPost.twitter_retweet_id)
        elsif aPost.twitter_reply_id && !aPost.twitter_reply_id.empty?
          theStatus = theClient.update(aPost.content, {in_reply_to_status_id: aPost.twitter_reply_id})
        else
          theStatus = theClient.update(aPost.content)
        end
        
        aPost.twitter_id = theStatus.id_str
      rescue Exception => e
        Rails.logger.warn "Error posting to twitter: #{aPost.content} => #{e.to_s}"
      end

    end

    def sendToFacebook( aPost )
      if (current_user.facebook_access_token.empty? )
        Rails.logger.warn "Error posting to facebook: user not connected"
        return
      end
      
      
      theGraph = Koala::Facebook::API.new(current_user.facebook_access_token)
      
      begin
        theResult = theGraph.put_connections("me", "feed", :message => aPost.content)
        
        aPost.facebook_id = theResult.id
      rescue Exception => e
        Rails.logger.warn "Error posting to facebook #{aPost.content} => #{e.to_s}"
      end
    end
    
    def load_tailgate
      @tailgate = Tailgate.find(params[:tailgate_id])
    end
end
