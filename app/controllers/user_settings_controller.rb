class UserSettingsController < ApplicationController
  before_filter :authenticate_user!  

  def edit
    @user = current_user
    @user_team = @user.user_teams.build
    @user_location = @user.user_locations.build
  end

  def update
    @user = User.find(params[:user][:id])
    
    respond_to do |format|
      if (current_user.id != @user.id)
        format.html { redirect_to user_settings_edit_path, error: 'Cannot update a different user.' }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      elsif @user.update_without_password(params[:user])
        sign_in @user, :bypass => true
        format.html { redirect_to root_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { 
          flash.now[:error] = 'Missed a few things...'
          render action: "edit"
        }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
    
  end
end
