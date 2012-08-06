class UserBragsController < ApplicationController
  before_filter :authenticate_user!  

  def create
    @user_brag =  current_user.user_brags.build(params[:user_brag])

    respond_to do |format|
      if @user_brag.save
        format.html { redirect_to current_user, notice: 'User brag was successfully created.' }
        format.json { render json: @user_brag, status: :created, location: @user_brag }
        format.js
      else
        format.html { redirect_to current_user, error: 'Unable to create brag' }
        format.json { render json: @user_brag.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @user_brag = current_user.user_brags.find(params[:id])
    @user_brag.destroy

    respond_to do |format|
      format.html { redirect_to current_user, notice: 'User brag was successfully deleted' }
      format.json { head :no_content }
      format.js
    end
  end
end
