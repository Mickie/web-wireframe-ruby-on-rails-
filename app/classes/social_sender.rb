class SocialSender
  include ApplicationHelper

  def sharePost( aPostId )
    thePost = Post.includes(:tailgate, :user).find_by_id(aPostId)
    
    if (thePost.twitter_flag)
      sendToTwitter(thePost)
    end
    if (thePost.facebook_flag)
      sendToFacebook(thePost)
    end
  end
  
  def shareFollow( aUserId, aTailgateId ) 
    theConnectionType = "#{ENV["FANZO_FACEBOOK_NAMESPACE"]}:join"
    addTailgateActionToGraph( aUserId, aTailgateId, theConnectionType )
  end

  def shareCreate( aUserId, aTailgateId ) 
    theConnectionType = "#{ENV["FANZO_FACEBOOK_NAMESPACE"]}:create"
    addTailgateActionToGraph( aUserId, aTailgateId, theConnectionType )
  end

  def sendFollowerTheirUpdate( aUserId )
    theUser = User.find(aUserId)
    if theUser
      Rails.logger.info "checking #{theUser.full_name}"
      
      theTailgateDetailsMap = {}
      theUser.followed_tailgates.where("posts_updated_at > ?", 24.hours.ago).each do | aTailgate |
        theNewPosts = []
        thePostsWithNewComments = []
        
        aTailgate.posts.where("updated_at > ?", 24.hours.ago).each do | aPost |
          if aPost.created_at > 24.hours.ago
            theNewPosts << aPost
            Rails.logger.info "found new post by user: #{aPost.user.name}"
          elsif aPost.comments_updated_at > 24.hours.ago
            thePostsWithNewComments << aPost 
            Rails.logger.info "found old post with new comment: #{aPost.comments.count}"
          end
        end
        
        theTailgateDetailsMap[aTailgate] = {}
        theTailgateDetailsMap[aTailgate][:newPosts] = theNewPosts
        theTailgateDetailsMap[aTailgate][:postsWithNewComments] = thePostsWithNewComments
      end
      
      if theTailgateDetailsMap.length > 0
        Rails.logger.info "Sending mail"
        UserMailer.updates_on_followed_fanzones( theUser, theTailgateDetailsMap ).deliver
      end
    end
  end
  
  def self.sendFollowersTheirUpdates
    if Rails.env.development?
      theListOfUsers = User.where(name:"Paul Ingalls")
    else
      theListOfUsers = User.all
    end
    
    theSender = SocialSender.new
    theListOfUsers.each do |aUser|
      theSender.delay.sendFollowerTheirUpdate(aUser.id)
    end

  end
  
  private
  
  def addTailgateActionToGraph( aUserId, aTailgateId, aConnectionType )
    theUser = User.find_by_id(aUserId)
    theTailgate = Tailgate.find_by_id(aTailgateId)
    
    if (theUser.facebook_access_token == nil || theUser.facebook_access_token.empty? )
      Rails.logger.warn "Error sharing #{ aConnectionType } => user not connected"
      return
    end
    
    
    theGraph = Koala::Facebook::API.new(theUser.facebook_access_token)
    
    begin
      theResult = theGraph.put_connections("me", 
                                            aConnectionType, 
                                            { fanzone: getTailgateBitly(theTailgate) })
    rescue Exception => e
      Rails.logger.warn "Error sharing #{ aConnectionType } to facebook => #{e.to_s}"
      raise e
    end
    
  end
  
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
      
      if aPost.image_url && aPost.image_url.length > 0
        thePicture = getBitlyForUrl( aPost.image_url )
      else
        thePicture = getLargeLogoBitly(aPost.tailgate.team)
      end
      
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