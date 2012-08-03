class WatchSitesController < ApplicationController
  before_filter :authenticate_admin!, except: [:search]

  # GET /watch_sites/search.js
  def search
    @locationQuery = params[:location_query]
    @watch_sites = WatchSite.includes(:team, :venue).where(team_id: params[:team_id]).near( @locationQuery, 50)
    
    if user_signed_in?
      current_user.user_locations.create(location_query: @locationQuery )
    end

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @watch_sites }
      format.js 
    end
  end
  
  # GET /watch_sites
  # GET /watch_sites.json
  def index
    @watch_sites = WatchSite.includes(:team, :venue).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @watch_sites }
    end
  end

  # GET /watch_sites/1
  # GET /watch_sites/1.json
  def show
    @watch_site = WatchSite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @watch_site }
    end
  end

  # GET /watch_sites/new
  # GET /watch_sites/new.json
  def new
    @watch_site = WatchSite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @watch_site }
    end
  end

  # GET /watch_sites/1/edit
  def edit
    @watch_site = WatchSite.find(params[:id])
  end

  # POST /watch_sites
  # POST /watch_sites.json
  def create
    @watch_site = WatchSite.new(params[:watch_site])

    respond_to do |format|
      if @watch_site.save
        format.html { redirect_to @watch_site, notice: 'Watch site was successfully created.' }
        format.json { render json: @watch_site, status: :created, location: @watch_site }
      else
        format.html { render action: "new" }
        format.json { render json: @watch_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /watch_sites/1
  # PUT /watch_sites/1.json
  def update
    @watch_site = WatchSite.find(params[:id])

    respond_to do |format|
      if @watch_site.update_attributes(params[:watch_site])
        format.html { redirect_to @watch_site, notice: 'Watch site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @watch_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watch_sites/1
  # DELETE /watch_sites/1.json
  def destroy
    @watch_site = WatchSite.find(params[:id])
    @watch_site.destroy

    respond_to do |format|
      format.html { redirect_to watch_sites_url }
      format.json { head :no_content }
    end
  end
end
