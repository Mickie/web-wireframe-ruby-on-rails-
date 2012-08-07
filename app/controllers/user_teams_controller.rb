class UserTeamsController < ApplicationController
  before_filter :authenticate_user!  

  def create
    @user_team = current_user.user_teams.build(params[:user_team])

    respond_to do |format|
      if @user_team.save
        format.html { redirect_to current_user, notice: 'Team was successfully added.' }
        format.json { render json: @user_team, status: :created, location: current_user }
        format.js
      else
        format.html { redirect_to current_user, error: 'Unable to add team.' }
        format.json { render json: @user_team.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end
  
  def destroy
    @user_team = current_user.user_teams.find(params[:id])
    @user_team.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
      format.js
    end
  end
  
end
