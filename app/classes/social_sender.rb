class SocialSender
  include ApplicationHelper

  def sharePost( aPostId )
    thePost = Post.includes(:tailgate, :user).find_by_id(aPostId)
    
    if (thePost.twitter_flag)
      sendToTwitter(thePost, getTailgateBitly(thePost.tailgate) )
    end
    if (thePost.facebook_flag)
      theLink = getTailgateBitly(aPost.tailgate)
      theName = aPost.tailgate.name
      theDescription = aPost.tailgate.description
      theCaption = "A Fanzo.me fanzone"
      sendToFacebook(thePost, theLink, theName, theDescription, theCaption)
    end
  end
  
  def shareEventPost( anEventPostId )
    theEventPost = EventPost.includes(:home_post, :visiting_post).find_by_id(anEventPostId)
    
    if theEventPost.home_post && theEventPost.visiting_post
      theUser = theEventPost.home_post.user
      if theUser.mine_or_following?(theEventPost.home_post.tailgate)
        thePostToShare = theEventPost.home_post
      else
        thePostToShare = theEventPost.visiting_post
      end
    elsif theEventPost.home_post
      thePostToShare = theEventPost.home_post
    else
      thePostToShare = theEventPost.visiting_post
    end
    
    if (thePostToShare.twitter_flag)
      sendToTwitter(thePostToShare, getEventBitly(theEventPost.event) )
    end
    
    if (thePostToShare.facebook_flag)
      theLink = getEventBitly(theEventPost.event)
      theName = "#{ theEventPost.event.visiting_team.name } at #{ theEventPost.event.home_team.name }"
      theDescription = "Watch the live social stream as the #{theEventPost.event.visiting_team.name } take on the #{ theEventPost.event.home_team.name }."
      theCaption = "Fanzo.me"
      sendToFacebook(thePostToShare, theLink, theName, theDescription, theCaption)
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
      theSender.delay.sendFollowerTheirUpdate(aUser.id) unless aUser.no_email_summary_of_followed_tailgates
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
  
  def sendToTwitter( aPost, aUrl )
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
    
    theText = "#{aPost.shortened_content} #{ aUrl }"

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

  def sendToFacebook( aPost, aUrl, aName, aDescription, aCaption )
    if (aPost.user.facebook_access_token == nil || aPost.user.facebook_access_token.empty? )
      Rails.logger.warn "Error posting to facebook: user not connected"
      return
    end
    
    theGraph = Koala::Facebook::API.new(aPost.user.facebook_access_token)
    
    begin
      
      if aPost.photo && aPost.photo.image
        thePicture = getBitlyForUrl( aPost.photo.image.url )
      elsif aPost.image_url && aPost.image_url.length > 0
        thePicture = getBitlyForUrl( aPost.image_url )
      else
        thePicture = getLargeLogoBitly(aPost.tailgate.team)
      end
      
      theResult = theGraph.put_connections("me", "feed", { message: aPost.content,
                                                            link: aUrl,
                                                            name: aName,
                                                            picture: thePicture,
                                                            description: aDescription,
                                                            caption: aCaption })

      aPost.facebook_id = theResult["id"]
    rescue Exception => e
      Rails.logger.warn "Error posting to facebook #{aPost.content} => #{e.to_s}"
      raise e
    end
  end
  

end