class UsersController < ApplicationController
  include Devise::Controllers::Rememberable
  
  before_filter :authenticate_user!, except: [:show, :client_facebook_login]  
  
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
  
  def client_facebook_login
    @user = UserFinder.findOrCreateUserFromFacebookId(params[:facebook_user_id], params[:facebook_access_token])   
    if (@user)
      sign_in("user", @user)
      remember_me(@user)
    end
    
    respond_to do |format|
      format.json { render json: @user.to_json(include: [ :user_post_votes, :user_comment_votes, :tailgates, :followed_tailgates, :tailgate_followers ]) }
    end
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
