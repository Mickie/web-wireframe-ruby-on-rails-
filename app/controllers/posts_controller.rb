class PostsController < ApplicationController
  include ApplicationHelper
  
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
  
  def getBitly(aTailgate)
    if aTailgate.bitly && aTailgate.bitly.length > 0
      return aTailgate.bitly
    end
    
    Bitly.use_api_version_3
    theClient = Bitly.new("paulingalls", "R_3448e4644415daf490d94e5ef0174509")
    
    begin
      theUrlResult = theClient.shorten(tailgate_url(aTailgate))
    
      aTailgate.bitly = theUrlResult.short_url
      aTailgate.save
    rescue Exception => e
      Rails.logger.warn "Error getting Foursquare ID: #{e.to_s}"
      return nil
    end
    
    return aTailgate.bitly
  end
  
  
  def sendToSocialNetworks( aPost )
    if (aPost.twitter_flag)
      sendToTwitter(aPost)
    end
    if (aPost.facebook_flag)
      sendToFacebook(aPost)
    end
  end
  
  def sendToTwitter( aPost )
    if (current_user.twitter_user_token == nil ||
        current_user.twitter_user_token.empty? ||
        current_user.twitter_user_secret == nil ||
        current_user.twitter_user_secret.empty?)
      Rails.logger.warn "Error posting to twitter: user not connected"
      return
    end
    
    theClient = Twitter::Client.new( 
      oauth_token: current_user.twitter_user_token,
      oauth_token_secret: current_user.twitter_user_secret
    )
    
    theText = "#{aPost.shortened_content} #{getBitly(aPost.tailgate)}"

    begin
      if aPost.twitter_retweet_id && !aPost.twitter_retweet_id.empty?
        theStatus = theClient.retweet(aPost.twitter_retweet_id)
      elsif aPost.twitter_reply_id && !aPost.twitter_reply_id.empty?
        theStatus = theClient.update(theText, {in_reply_to_status_id: aPost.twitter_reply_id})
      else
        theStatus = theClient.update(theText)
      end
      
      aPost.twitter_id = theStatus.attrs['id_str']
    rescue Exception => e
      Rails.logger.warn "Error posting to twitter: #{aPost.content} => #{e.to_s}"
    end

  end

  def sendToFacebook( aPost )
    if (current_user.facebook_access_token == nil || current_user.facebook_access_token.empty? )
      Rails.logger.warn "Error posting to facebook: user not connected"
      return
    end
    
    
    theGraph = Koala::Facebook::API.new(current_user.facebook_access_token)
    
    begin
      theLink = getBitly(aPost.tailgate)
      puts(theLink)
      Rails.logger.warn "theLink = #{theLink}"
      theResult = theGraph.put_connections("me", "feed", { message: aPost.content,
                                                            link: theLink,
                                                            name: aPost.tailgate.name,
                                                            picture: logoPath(aPost.tailgate.team.slug, :medium),
                                                            description: "Find this and other fanzones at FANZO.me",
                                                            caption: "A fanzone about the #{aPost.tailgate.team.name}" })

      aPost.facebook_id = theResult["id"]
    rescue Exception => e
      Rails.logger.warn "Error posting to facebook #{aPost.content} => #{e.to_s}"
    end
  end
  
  def load_tailgate
    @tailgate = Tailgate.find(params[:tailgate_id])
  end
end
