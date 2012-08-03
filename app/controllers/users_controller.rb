class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:show]  
  
  def show
    @user = User.find(params[:id])
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
      WatchSite.near(anAddress, 50).each do | aWatchSite |
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
