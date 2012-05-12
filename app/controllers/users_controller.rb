class UsersController < ApplicationController
  before_filter :authenticate_user!  
  
  def show
    @user = User.find(params[:id])
    @user_team = UserTeam.new(user_id:@user.id)
  end
  
  def connect_twitter
    if request.headers["Referer"]
      session['user_return_to'] = request.headers["Referer"]
    end
    @user = User.find(params[:id])
  end
end
