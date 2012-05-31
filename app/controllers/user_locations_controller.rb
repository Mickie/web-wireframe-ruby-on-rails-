class UserLocationsController < ApplicationController
  before_filter :authenticate_user!  
  
  def create
    @user_location = UserLocation.new(params[:user_location])
    @user = User.find(params[:user_id])
    @user_location.user = @user 

    respond_to do |format|
      if @user != current_user
        format.html { redirect_to current_user, error: 'Cannot add a location to a different user' }
        format.json { render json: { error: 'Cannot add a location to a different user' }, status: :unprocessable_entity }
      elsif @user_location.save
        format.html { redirect_to @user, notice: 'User location was successfully created.' }
        format.json { render json: @user_location, status: :created, location: @user_location }
      else
        format.html { redirect_to @user, error: 'Unable to add location.' }
        format.json { render json: @user_location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_location = UserLocation.find(params[:id])
    @user = User.find(params[:user_id])
    @user_location.destroy

    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.json { head :no_content }
    end
  end
end
