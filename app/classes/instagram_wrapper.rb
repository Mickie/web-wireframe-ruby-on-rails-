class InstagramWrapper
  
  def initialize( anAccessToken )
    @accessToken = anAccessToken
  end
  
  def getMediaForTag( aTag )
    theTagKey = "media_for_" + aTag

    theMedia = Rails.cache.read(theTagKey)
    
    if !theMedia
      theClient = getClient
      begin
        theMedia = theClient.tag_recent_media(aTag)
        Rails.cache.write(theTagKey, theMedia, expires_in: 59.seconds)
      rescue Exception => e
        theMedia = []
        Rails.logger.warn "Error getting instagram media for tag: #{theTag} => #{e.to_s}"
      end
    end
    
    return theMedia
  end
  
  def getSortedInstagramTags( aStringOfHashTags )
    theClient = getClient
    
    theArrayOfTagArrays = []

    i = 0
    aStringOfHashTags.split(",").each do |aHashTag|
      theCachedContent = Rails.cache.read(aHashTag)
      if theCachedContent
        theArrayOfTagArrays[i] = theCachedContent
        i += 1
      else
        theTag = aHashTag.gsub(/[\s,",#]/, "")
        begin
          theArrayOfTagArrays[i] = theClient.tag_search(theTag)
          Rails.cache.write(aHashTag, theArrayOfTagArrays[i], expires_in: 1.day)
          i += 1
        rescue Exception => e
          Rails.logger.warn "Error getting tags for #{theTag} from instagram: #{e.to_s}"
        end
      end
    end
    
    return mergeTags( theArrayOfTagArrays )    
  end
  
  def mergeTags( anArrayOfTagArrays )
    theResult = []

    theCurrentIndex = 0
    theAddedFlag = false;
    begin
      theCurrentSet = []
      theAddedFlag = false;
      anArrayOfTagArrays.each do |aTagArray|
        if (theCurrentIndex < aTagArray.length)
          theCurrentSet.push(aTagArray[theCurrentIndex])
          theAddedFlag = true
        end
      end
      theResult += theCurrentSet.sort {|aLeft, aRight| aRight.media_count <=> aLeft.media_count }
      theCurrentIndex += 1
    end while theAddedFlag
    
    return theResult
  end
  
  def getClient
    if @accessToken && @accessToken.length > 0
      return Instagram.client( access_token: @accessToken )
    else
      return Instagram.client()
    end
  end
  
  
end
