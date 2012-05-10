class TwitterProxyController < ApplicationController
  before_filter :authenticate_user!
  before_filter :checkForTwitterCredentials
  
  
  def update_status

    theClient = Twitter::Client.new( 
      :oauth_token => current_user.twitter_user_token,
      :oauth_token_secret => current_user.twitter_user_secret
      )
      
    if params[:replyId]
      theStatus = theClient.update(params[:statusText], {in_reply_to_status_id: params[:replyId]})
    else
      theStatus = theClient.update(params[:statusText])
    end

    respond_to do |format|
      format.json { render json: theStatus }
    end

  end

  def retweet
    
    theClient = Twitter::Client.new( 
      :oauth_token => current_user.twitter_user_token,
      :oauth_token_secret => current_user.twitter_user_secret
      )
      
    theStatus = theClient.retweet(params[:tweetId])

    respond_to do |format|
      format.json { render json: theStatus }
    end
  end

  def favorite

    theClient = Twitter::Client.new( 
      :oauth_token => current_user.twitter_user_token,
      :oauth_token_secret => current_user.twitter_user_secret
      )
      
    theStatus = theClient.favorite(params[:favoriteId])

    respond_to do |format|
      format.json { render json: theStatus }
    end
  end
  
  private
  
  def checkForTwitterCredentials
    redirect_to(new_user_session_path) unless current_user.twitter_user_token && current_user.twitter_user_secret
  end
  
end
