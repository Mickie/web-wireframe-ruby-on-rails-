class UserBragsController < ApplicationController
  before_filter :authenticate_user!  

  def create
    if params[:user_brag][:brag_id] && params[:user_brag][:brag_id].length > 0
      @user_brag = UserBrag.new(brag_id:params[:user_brag][:brag_id], type: params[:user_brag][:type])
    else
      @user_brag =  UserBrag.new(params[:user_brag])
    end
    @user_brag.user_id = current_user.id

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
    @user_brag = UserBrag.find(params[:id])

    respond_to do |format|
      if @user_brag.user_id == current_user.id
        @user_brag.destroy
        format.html { redirect_to current_user, notice: 'User brag was successfully deleted' }
        format.json { head :no_content }
        format.js
      else
        format.html { redirect_to current_user, error: "Cannot delete another user's Shout" }
        format.json { head :no_content }
        format.js
      end
    end
  end
end
