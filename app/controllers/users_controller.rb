class UsersController < ApplicationController
  before_filter :authenticate_user!  
  
  def show
    @user = User.find(params[:id])
    @user_team = UserTeam.new(user_id:@user.id)
    @user_location = UserLocation.new(user_id:@user.id)
    @user_location.build_location
    
    theCoordinates = request.location.coordinates
    theCityState = "#{request.location.city}, #{request.location.state_code}"
    if request.remote_ip == "127.0.0.1"
      theCoordinates = "Northwest University, Kirkland WA"
      theCityState = "Kirkland, WA"
    end
    
    @localWatchSites = WatchSite.near(theCoordinates, 60)
    
    
    @locationsWithTailgateVenues = [ { locationName: "#{theCityState}", tailgateVenueList: TailgateVenue.near(theCoordinates, 30) } ]
    @locationsWithTeamWatchSites = [ { locationName: "#{theCityState}", localTeamWatchSiteList: getWatchSitesForLocation(@user, theCoordinates)}]
    
    @user.locations.each do |aLocation|
      @locationsWithTailgateVenues.push( { locationName: "#{aLocation.city}, #{aLocation.state.abbreviation}",
                                           tailgateVenueList: TailgateVenue.near(aLocation.one_line_address )})
      @locationsWithTeamWatchSites.push( { locationName: "#{aLocation.city}, #{aLocation.state.abbreviation}",
                                           localTeamWatchSiteList: getWatchSitesForLocation(@user, aLocation.one_line_address)})
    end
    
  end
  
  def connect_twitter
    if request.headers["Referer"]
      session['user_return_to'] = request.headers["Referer"]
    end
    @user = User.find(params[:id])
  end

  def connect_instagram
    if request.headers["Referer"]
      session['user_return_to'] = request.headers["Referer"]
    end
    @user = User.find(params[:id])
  end

  private
    
  def getWatchSitesForLocation( aUser, anAddress )
    theLocalTeamWatchSites = []
    if (@user.teams.length > 0)
      WatchSite.near(anAddress).each do | aWatchSite |
        @user.teams.each do | aTeam |
          if aWatchSite.team.id == aTeam.id
            theLocalTeamWatchSites.push(aWatchSite)
          end
        end
      end
    end
    
    return theLocalTeamWatchSites
  end

end
