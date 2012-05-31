class UserTeamsController < ApplicationController
  before_filter :authenticate_user!  

  def create
    @user_team = UserTeam.new(params[:user_team])
    @user = User.find(params[:user_id])
    @user_team.user = @user

    respond_to do |format|
      if @user_team.save
        format.html { redirect_to @user, notice: 'Team was successfully added.' }
        format.json { render json: @user_team, status: :created, location: @user }
      else
        format.html { redirect_to @user, error: 'Unable to add team.' }
        format.json { render json: @user_team.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user_team = UserTeam.find(params[:id])
    @user = User.find(params[:user_id])
    @user_team.destroy

    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.json { head :no_content }
    end
  end
  
end
