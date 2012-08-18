class InstagramProxyController < ApplicationController

  def find_tags_for_team
    theTeam = Team.find(params[:team_id])
    theWrapper = InstagramWrapper.new(user_signed_in? ? current_user.instagram_user_token : nil)
    theTags = theWrapper.getSortedInstagramTags(theTeam.social_info.hash_tags)    

    respond_to do |format|
      format.json { render json: theTags.slice(0,2) }
    end
  end

  def find_tags_for_fanzone
    theFanzone = Tailgate.find(params[:fanzone_id])
    theWrapper = InstagramWrapper.new(user_signed_in? ? current_user.instagram_user_token : nil)
    theTags = theWrapper.getSortedInstagramTags(theFanzone.topic_tags)

    respond_to do |format|
      format.json { render json: theTags.slice(0,2) }
    end
  end

  def media_for_tag
    theTag = params[:tag]
    theWrapper = InstagramWrapper.new(user_signed_in? ? current_user.instagram_user_token : nil)
    theMedia = theWrapper.getMediaForTag( theTag )
    
    respond_to do |format|
      format.json { render json: theMedia }
    end
  end
  
end
