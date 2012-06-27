class TailgateFollowersController < ApplicationController
  before_filter :authenticate_user!  

  def create
    @tailgate_follower = current_user.tailgate_followers.build( tailgate_id: params[:tailgate_follower][:tailgate_id])
    
    respond_to do |format|
      if @tailgate_follower.save
        format.html { redirect_to root_path, notice: 'Successfully followed the fanzone' }
        format.json { render json: @tailgate_follower, status: :created, location: @user }
        format.js
      else
        format.html { redirect_to root_path, error: 'Unable to follow the fanzone.' }
        format.json { render json: @tailgate_follower.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end
  
  def destroy
    @tailgate_follower = TailgateFollower.find(params[:id])
    current_user.unfollow!( @tailgate_follower.tailgate )
    @tailgate_follower.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
      format.js
    end
  end
  
end