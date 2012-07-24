class FanzoTipsController < ApplicationController
  before_filter :authenticate_admin!

  # GET /fanzo_tips
  # GET /fanzo_tips.json
  def index
    @fanzo_tips = FanzoTip.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fanzo_tips }
    end
  end

  # GET /fanzo_tips/1
  # GET /fanzo_tips/1.json
  def show
    @fanzo_tip = FanzoTip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fanzo_tip }
    end
  end

  # GET /fanzo_tips/new
  # GET /fanzo_tips/new.json
  def new
    @fanzo_tip = FanzoTip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fanzo_tip }
    end
  end

  # GET /fanzo_tips/1/edit
  def edit
    @fanzo_tip = FanzoTip.find(params[:id])
  end

  # POST /fanzo_tips
  # POST /fanzo_tips.json
  def create
    @fanzo_tip = FanzoTip.new(params[:fanzo_tip])

    respond_to do |format|
      if @fanzo_tip.save
        format.html { redirect_to @fanzo_tip, notice: 'Fanzo tip was successfully created.' }
        format.json { render json: @fanzo_tip, status: :created, location: @fanzo_tip }
      else
        format.html { render action: "new" }
        format.json { render json: @fanzo_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fanzo_tips/1
  # PUT /fanzo_tips/1.json
  def update
    @fanzo_tip = FanzoTip.find(params[:id])

    respond_to do |format|
      if @fanzo_tip.update_attributes(params[:fanzo_tip])
        format.html { redirect_to @fanzo_tip, notice: 'Fanzo tip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fanzo_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fanzo_tips/1
  # DELETE /fanzo_tips/1.json
  def destroy
    @fanzo_tip = FanzoTip.find(params[:id])
    @fanzo_tip.destroy

    respond_to do |format|
      format.html { redirect_to fanzo_tips_url }
      format.json { head :no_content }
    end
  end
end
