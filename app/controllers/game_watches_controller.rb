class GameWatchesController < ApplicationController
  # GET /game_watches
  # GET /game_watches.json
  def index
    @game_watches = GameWatch.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @game_watches }
    end
  end

  # GET /game_watches/1
  # GET /game_watches/1.json
  def show
    @game_watch = GameWatch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game_watch }
    end
  end

  # GET /game_watches/new
  # GET /game_watches/new.json
  def new
    @game_watch = GameWatch.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game_watch }
    end
  end

  # GET /game_watches/1/edit
  def edit
    @game_watch = GameWatch.find(params[:id])
  end

  # POST /game_watches
  # POST /game_watches.json
  def create
    @game_watch = GameWatch.new(params[:game_watch])

    respond_to do |format|
      if @game_watch.save
        format.html { redirect_to @game_watch, notice: 'Game watch was successfully created.' }
        format.json { render json: @game_watch, status: :created, location: @game_watch }
      else
        format.html { render action: "new" }
        format.json { render json: @game_watch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /game_watches/1
  # PUT /game_watches/1.json
  def update
    @game_watch = GameWatch.find(params[:id])

    respond_to do |format|
      if @game_watch.update_attributes(params[:game_watch])
        format.html { redirect_to @game_watch, notice: 'Game watch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game_watch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_watches/1
  # DELETE /game_watches/1.json
  def destroy
    @game_watch = GameWatch.find(params[:id])
    @game_watch.destroy

    respond_to do |format|
      format.html { redirect_to game_watches_url }
      format.json { head :no_content }
    end
  end
end
