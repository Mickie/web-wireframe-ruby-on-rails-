class VenuesController < ApplicationController
  before_filter :authenticate_admin!, except: [:show]
  before_filter :authenticate_user!, only: [:show] 

  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.includes(:location => :state).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venues }
    end
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
    @venue = Venue.find(params[:id])
    
    @foursquare_id = getFoursquareId @venue

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venue }
    end
  end
  
  def getFoursquareId(aVenue)
    if aVenue.foursquare_id
      return aVenue.foursquare_id
    end
    
    theId = ENV["FANZO_FOURSQUARE_CLIENT_ID"]
    theSecret = ENV["FANZO_FOURSQUARE_CLIENT_SECRET"]
    
    if current_user.foursquare_user_id
      theClient = Foursquare2::Client.new(:oauth_token => current_user.foursquare_access_token)
    else
      theClient = Foursquare2::Client.new(:client_id => theId, :client_secret => theSecret)
    end
    
    theResponse = theClient.search_venues(ll: "#{aVenue.location.latitude},#{aVenue.location.longitude}", 
                                          query: aVenue.name, 
                                          intent:'match',
                                          v:'20120609')
    theResponse[:venues].each do |aFoursquareVenue|
      if aFoursquareVenue[:location]
        if aVenue.location.isSimilarAddress?(aFoursquareVenue[:location][:address], aFoursquareVenue[:location][:postal_code])
          aVenue.foursquare_id = aFoursquareVenue[:id]
          aVenue.save
          return aVenue.foursquare_id
        end
      end
      
      if aFoursquareVenue[:name]
        if aVenue.isSimilarName? aFoursquareVenue[:name] 
          aVenue.foursquare_id = aFoursquareVenue[:id]
          aVenue.save
          return aVenue.foursquare_id
        end
      end  
    end   
                                       
    return aVenue.foursquare_id
  end
  

  # GET /venues/new
  # GET /venues/new.json
  def new
    @venue = Venue.new
    @venue.build_location
    @venue.build_social_info

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(params[:venue])

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render json: @venue, status: :created, location: @venue }
      else
        format.html { render action: "new" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    @venue = Venue.find(params[:id])

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy

    respond_to do |format|
      format.html { redirect_to venues_url }
      format.json { head :no_content }
    end
  end
  
end
