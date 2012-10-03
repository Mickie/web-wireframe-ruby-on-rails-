class StaticPagesController < ApplicationController
  def home
    
    if false # browser.iphone?
      return render partial: "layouts/phone", locals: { aDevice: params[:device], aTailgate: nil }
    end

    @tailgate = nil;
    
    @currentCityState = getCityStateFromRequest( request )
    if @currentCityState.blank?
      if current_user && !current_user.location.blank?
        @currentCityState = current_user.location
      elsif current_user && !current_user.user_locations.empty?
        @currentCityState = current_user.user_locations.first.location_query
      else
        @currentCityState = "Seattle, WA"
      end
    end

    if current_user && current_user.myFanzones.length < 2
      @tailgates = Tailgate.includes(:team, :posts => :user).order("posts_updated_at DESC").page(1) 
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
    
    render "tailgates/show"
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
end
