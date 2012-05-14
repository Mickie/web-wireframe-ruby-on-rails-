class InstagramProxyController < ApplicationController
  before_filter :authenticate_user!

  def find_tags
    theTeam = Team.find(params[:team_id])
    
    theClient = nil
    if current_user.instagram_user_token
      theClient = Instagram.client( access_token: current_user.instagram_user_token )
    else
      theClient = Instagram.client()
    end
    
    
    theTags = []
    theTeam.social_info.hash_tags.split(" ").each do |aHashTag|
      theTags += theClient.tag_search(aHashTag)
    end
    
    theTags = theTags.sort {|aLeft, aRight| aRight.media_count <=> aLeft.media_count }

    respond_to do |format|
      format.json { render json: theTags.slice(0,2) }
    end
  end

  def media_for_tag
    theMedia = []

    theClient = Instagram.client()

    theMedia = theClient.tag_recent_media(params[:tag])

    respond_to do |format|
      format.json { render json: theMedia }
    end
  end
  
end
