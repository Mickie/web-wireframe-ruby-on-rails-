class TailgateVenuesController < ApplicationController
  # GET /tailgate_venues
  # GET /tailgate_venues.json
  def index
    @tailgate_venues = TailgateVenue.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tailgate_venues }
    end
  end

  # GET /tailgate_venues/1
  # GET /tailgate_venues/1.json
  def show
    @tailgate_venue = TailgateVenue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tailgate_venue }
    end
  end

  # GET /tailgate_venues/new
  # GET /tailgate_venues/new.json
  def new
    @tailgate_venue = TailgateVenue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tailgate_venue }
    end
  end

  # GET /tailgate_venues/1/edit
  def edit
    @tailgate_venue = TailgateVenue.find(params[:id])
  end

  # POST /tailgate_venues
  # POST /tailgate_venues.json
  def create
    @tailgate_venue = TailgateVenue.new(params[:tailgate_venue])

    respond_to do |format|
      if @tailgate_venue.save
        format.html { redirect_to @tailgate_venue, notice: 'Tailgate venue was successfully created.' }
        format.json { render json: @tailgate_venue, status: :created, location: @tailgate_venue }
      else
        format.html { render action: "new" }
        format.json { render json: @tailgate_venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tailgate_venues/1
  # PUT /tailgate_venues/1.json
  def update
    @tailgate_venue = TailgateVenue.find(params[:id])

    respond_to do |format|
      if @tailgate_venue.update_attributes(params[:tailgate_venue])
        format.html { redirect_to @tailgate_venue, notice: 'Tailgate venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tailgate_venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tailgate_venues/1
  # DELETE /tailgate_venues/1.json
  def destroy
    @tailgate_venue = TailgateVenue.find(params[:id])
    @tailgate_venue.destroy

    respond_to do |format|
      format.html { redirect_to tailgate_venues_url }
      format.json { head :no_content }
    end
  end
end
