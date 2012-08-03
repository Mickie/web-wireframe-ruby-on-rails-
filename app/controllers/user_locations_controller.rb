class UserLocationsController < ApplicationController
  before_filter :authenticate_user!  
  
  def create
    @user_location = current_user.user_locations.build(location_query: params[:user_location][:location_query])

    respond_to do |format|
      if @user_location.save
        format.html { redirect_to current_user, notice: 'User location was successfully created.' }
        format.json { render json: @user_location, status: :created, location: @user_location }
        format.js
      else
        format.html { redirect_to current_user, error: 'Unable to add location.' }
        format.json { render json: @user_location.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @user_location = current_user.user_locations.find(params[:id])
    @user_location.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
      format.js
    end
  end
end
