class StaticPagesController < ApplicationController
  include Devise::Controllers::Rememberable
  
  def home
    
    if false # browser.iphone?
      return render partial: "layouts/phone", locals: { aDevice: params[:device], aTailgate: nil }
    end

    prepareTailgateForDisplay
  end
  
  def canvas
    if params[:signed_request]
      theAuth = Koala::Facebook::OAuth.new(ENV["FANZO_FACEBOOK_APP_ID"], ENV["FANZO_FACEBOOK_APP_SECRET"])
      theResult = theAuth.parse_signed_request(params[:signed_request])
      if theResult["user_id"]
        theUser = User.find_by_facebook_user_id(theResult["user_id"])
        sign_in theUser
        remember_me theUser
      end
    end
    
    prepareTailgateForDisplay
  end
  
  def pageTab
    thePageId = nil
    theUser = nil
    theAdminFlag = false

    if params[:signed_request]
      theAuth = Koala::Facebook::OAuth.new(ENV["FANZO_FACEBOOK_APP_ID"], ENV["FANZO_FACEBOOK_APP_SECRET"])
      theResult = theAuth.parse_signed_request(params[:signed_request])
      
      if theResult["user_id"]
        theUser = User.find_by_facebook_user_id(theResult["user_id"])
        sign_in theUser
        remember_me theUser
      end
      
      if theResult["page"]
        thePageId = theResult["page"]["id"]
        theAdminFlag = theResult["page"]["admin"]
      end
    end
    
    theFacebookPage = FacebookPage.find_by_page_id(thePageId)
    if theFacebookPage
      @tailgate = Tailgate.includes(:user, :team, :posts => [ {:comments => :user}, :user ] ).find(theFacebookPage.tailgate_id)
      @currentCityState = getLocationQueryFromRequestOrUser( request, current_user )
      @post = Post.new
      @post.build_photo
      @localTeamWatchSites = @tailgate.team.watch_sites.includes(:venue => {:location => :state}).near(@currentCityState, 50);
      
      return render "facebook_pages/show", layout: false
    elsif theUser && theAdminFlag
      @facebook_page = FacebookPage.new(page_id: thePageId)
      return render "facebook_pages/new", layout: false
    else
      return render inline: "<h1>Sorry, there was a problem getting the page...</h1>"
    end
  end

  def about
  end
  
  def channel
    cache_expire = 1.year
    response.headers["Pragma"] = "public"
    response.headers["Cache-Control"] = "max-age=#{cache_expire.to_i}"
    response.headers["Expires"] = (Time.now + cache_expire).strftime("%d %m %Y %H:%I:%S %Z")
    respond_to do |format|
      format.html { render :layout => false, :inline => "<script src='//connect.facebook.net/en_US/all.js'></script>" }
    end
        
  end
  
  private
  
  def prepareTailgateForDisplay
    @tailgate = nil;
    @currentCityState = getLocationQueryFromRequestOrUser( request, current_user )

    if current_user && current_user.myFanzones.length < 2
      @tailgates = Tailgate.includes(:team, :posts => :user).order("posts_updated_at DESC").page(1)
      render "tailgates/index" 
      return
    elsif current_user
      @tailgate = current_user.myFanzones.first
    elsif !@currentCityState.blank?
      theClosestTeam = Team.near(@currentCityState, 100).first
      if !theClosestTeam
        theClosestTeam = Team.find(291)
      end
      @tailgate = Tailgate.includes(:user, 
                                    :team, 
                                    :posts => [ {:comments => :user}, 
                                                :user ] ).where(official:true).find_by_team_id(theClosestTeam.id)
    end

    if @tailgate.nil?
      @tailgate = Tailgate.includes(:user, :team, :posts => [ {:comments => :user}, :user ] ).find(226)
    end
    
    @post = Post.new
    @post.build_photo
    
    @localTeamWatchSites = @tailgate.team.watch_sites.includes(:venue => {:location => :state}).near(@currentCityState, 50);
    
  end
end
