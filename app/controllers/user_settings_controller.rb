class UserSettingsController < ApplicationController
  before_filter :authenticate_user!  

  def edit
    @user = current_user
    @user_team = @user.user_teams.build
    @user_location = @user.user_locations.build
    @iWasThereBrag = @user.i_was_there_brags.build
    @iWasThereBrag.build_brag
    @iWatchedBrag = @user.i_watched_brags.build
    @iWatchedBrag.build_brag
    @iWishBrag = @user.i_wish_brags.build
    @iWishBrag.build_brag
  end

  def update
    @user = current_user
    
    respond_to do |format|
      if @user.update_without_password(params[:user])
        sign_in @user, :bypass => true
        format.html { redirect_to current_user, notice: 'User was successfully updated.' }
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
