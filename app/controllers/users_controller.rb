class UsersController < ApplicationController
  before_filter :authenticate_user!  
  
  def show
    @user = User.find(params[:id])
    @user_team = UserTeam.new(user_id:@user.id)
    
    theCoordinates = request.location.coordinates
    if request.remote_ip == "127.0.0.1"
      theCoordinates = "Northwest University, Kirkland WA"
    end
    
    @localWatchSites = WatchSite.near(theCoordinates, 60)
    @localTailgateVenues = TailgateVenue.near(theCoordinates, 30)
    
    @localTeamWatchSites = [];
    if (@user.teams.length > 0)
      @localWatchSites.each do | aWatchSite |
        @user.teams.each do | aTeam |
          if aWatchSite.team.id == aTeam.id
            @localTeamWatchSites.push(aWatchSite)
          end
        end
      end
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

end
