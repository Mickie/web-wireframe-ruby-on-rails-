class SocialSender

  def sharePost( aPostId )
    thePost = Post.includes(:tailgate, :user).find_by_id(aPostId)
    
    if (thePost.twitter_flag)
      sendToTwitter(thePost)
    end
    if (thePost.facebook_flag)
      sendToFacebook(thePost)
    end
  end
  
  private
  
  def sendToTwitter( aPost )
    if (aPost.user.twitter_user_token == nil ||
        aPost.user.twitter_user_token.empty? ||
        aPost.user.twitter_user_secret == nil ||
        aPost.user.twitter_user_secret.empty?)
      Rails.logger.warn "Error posting to twitter: user not connected"
      return
    end
    
    theClient = Twitter::Client.new( 
      oauth_token: aPost.user.twitter_user_token,
      oauth_token_secret: aPost.user.twitter_user_secret
    )
    
    theText = "#{aPost.shortened_content} #{ getTailgateBitly(aPost.tailgate) }"

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
      raise e
    end

  end

  def sendToFacebook( aPost )
    if (aPost.user.facebook_access_token == nil || aPost.user.facebook_access_token.empty? )
      Rails.logger.warn "Error posting to facebook: user not connected"
      return
    end
    
    
    theGraph = Koala::Facebook::API.new(aPost.user.facebook_access_token)
    
    begin
      theLink = getTailgateBitly(aPost.tailgate)
      thePicture = getLargeLogoBitly(aPost.tailgate.team)
      
      theResult = theGraph.put_connections("me", "feed", { message: aPost.content,
                                                            link: theLink,
                                                            name: aPost.tailgate.name,
                                                            picture: thePicture,
                                                            description: aPost.tailgate.description,
                                                            caption: "A Fanzo.me fanzone" })

      aPost.facebook_id = theResult["id"]
    rescue Exception => e
      Rails.logger.warn "Error posting to facebook #{aPost.content} => #{e.to_s}"
      raise e
    end
  end
  

end