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
  
  private
  
  def getSortedInstagramTags( aStringOfHashTags )
    theClient = getClient
    
    theTags = []

    begin
      aStringOfHashTags.split(",").each do |aHashTag|
        theTags += theClient.tag_search(aHashTag.gsub(/\s/, ""))
      end
    rescue Exception => e
      Rails.logger.warn "Error getting tags from instagram: #{e.to_s}"
    end
    
    theTags = theTags.sort {|aLeft, aRight| aRight.media_count <=> aLeft.media_count }

    return theTags    
  end
  
  def getClient
    if signed_in? && current_user.instagram_user_token
      return Instagram.client( access_token: current_user.instagram_user_token )
    else
      return Instagram.client()
    end
  end
  
end
