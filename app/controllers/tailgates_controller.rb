class TailgatesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy] 


  # GET /tailgates
  # GET /tailgates.json
  def index
    @tailgates = Tailgate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tailgates }
    end
  end

  # GET /tailgates/1
  # GET /tailgates/1.json
  def show
    @tailgate = Tailgate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tailgate }
    end
  end

  # GET /tailgates/new
  # GET /tailgates/new.json
  def new
    @tailgate = Tailgate.new
    @tailgate.user_id = current_user.id

    @tailgateVenue = TailgateVenue.new tailgate:@tailgate

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tailgate }
    end
  end

  # GET /tailgates/1/edit
  def edit
    @tailgate = Tailgate.find(params[:id])
    
    if (@tailgate.user_id != current_user.id)
      redirect_to user_path(current_user), alert: 'Cannot edit a tailgate owned by another user.'
    end
  end

  # POST /tailgates
  # POST /tailgates.json
  def create
    @tailgate = Tailgate.new(params[:tailgate])

    respond_to do |format|
      if (@tailgate.user_id != current_user.id)
        format.html { render action: "new", notice: 'Cannot create a tailgate for another user.' }
        format.json { render json: @tailgate.errors, status: :unprocessable_entity }
      elsif @tailgate.save
        format.html { redirect_to @tailgate, notice: 'Tailgate was successfully created.' }
        format.json { render json: @tailgate, status: :created, location: @tailgate }
      else
        format.html { render action: "new" }
        format.json { render json: @tailgate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tailgates/1
  # PUT /tailgates/1.json
  def update
    @tailgate = Tailgate.find(params[:id])

    respond_to do |format|
      if (@tailgate.user_id != current_user.id)
        format.html { redirect_to user_path(current_user), notice: 'Cannot update a tailgate owned by another user.' }
        format.json { render json: @tailgate.errors, status: :unprocessable_entity }
      elsif @tailgate.update_attributes(params[:tailgate])
        format.html { redirect_to @tailgate, notice: 'Tailgate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tailgate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tailgates/1
  # DELETE /tailgates/1.json
  def destroy
    @tailgate = Tailgate.find(params[:id])
    
    if (@tailgate.user_id == current_user.id)
      @tailgate.destroy
    end
    
    respond_to do |format|
      if (@tailgate.user_id != current_user.id)
        format.html { redirect_to user_path(current_user), notice: 'Cannot delete a tailgate owned by another user.' }
        format.json { render json: @tailgate.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to tailgates_url }
        format.json { head :no_content }
      end
    end
  end
end