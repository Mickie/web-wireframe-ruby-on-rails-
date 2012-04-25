class UsersController < ApplicationController
  before_filter :authenticate_user!  
  
  def show
    @user = User.find(params[:id])
    @user_team = UserTeam.new(user_id:@user.id)
  end
  
end
