class TailgateFollowersController < ApplicationController
  before_filter :authenticate_user!  

  def create
    @tailgate_follower = current_user.tailgate_followers.build( tailgate_id: params[:tailgate_follower][:tailgate_id])
    
    respond_to do |format|
      if @tailgate_follower.save

        unless current_user.no_fb_share_on_follow_tailgate
          SocialSender.new.delay.shareFollow(current_user.id, @tailgate_follower.tailgate.id) 
        end

        unless @tailgate_follower.tailgate.user.no_email_on_follows
          UserMailer.delay.new_follower(@tailgate_follower.id)
        end

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
    @tailgate = @tailgate_follower.tailgate

    current_user.unfollow!( @tailgate )

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
      format.js
    end
  end
  
end
