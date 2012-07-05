class InstagramProxyController < ApplicationController

  def find_tags_for_team
    theTeam = Team.find(params[:team_id])
    theTags = getSortedInstagramTags(theTeam.social_info.hash_tags)    

    respond_to do |format|
      format.json { render json: theTags.slice(0,2) }
    end
  end

  def find_tags_for_fanzone
    theFanzone = Tailgate.find(params[:fanzone_id])
    theTags = getSortedInstagramTags(theFanzone.topic_tags)

    respond_to do |format|
      format.json { render json: theTags.slice(0,2) }
    end
  end

  def media_for_tag
    theMedia = []

    theClient = getClient
    begin
      theMedia = theClient.tag_recent_media(params[:tag])
    rescue Exception => e
      Rails.logger.warn "Error getting instagram media for tag: #{params[:tag]} => #{e.to_s}"
    end

    respond_to do |format|
      format.json { render json: theMedia }
    end
  end
  
  def getSortedInstagramTags( aStringOfHashTags )
    theClient = getClient
    
    theArrayOfTagArrays = []

    begin
      i = 0
      aStringOfHashTags.split(",").each do |aHashTag|
        theArrayOfTagArrays[i] = theClient.tag_search(aHashTag.gsub(/\s/, ""))
        i += 1
      end
    rescue Exception => e
      Rails.logger.warn "Error getting tags from instagram: #{e.to_s}"
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
    if signed_in? && current_user.instagram_user_token
      return Instagram.client( access_token: current_user.instagram_user_token )
    else
      return Instagram.client()
    end
  end
  
end
