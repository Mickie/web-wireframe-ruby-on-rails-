require 'rails3-jquery-autocomplete'

class TeamsController < ApplicationController
  before_filter :authenticate_admin!, except: [:index, :show, :autocomplete_team_name]
  before_filter :authenticate_user!, only: [:index, :show] 

  autocomplete :team, :name, full: true, scopes: [:visible]

  def index
    if params[:sport_id]
      @teams = Team.includes(:social_info, :league, :sport, :location => :state).where("sport_id = ?", params[:sport_id])
    elsif params[:league_id]    
      @teams = Team.includes(:social_info, :league, :sport, :location => :state).where("league_id = ?", params[:league_id])
    else    
      @teams = Team.includes(:social_info, :league, :sport, :location => :state).all
    end
    
    @teams.each do |aTeam|
      aTeam.build_social_info unless aTeam.social_info
    end 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  def show
    @team = Team.includes(:social_info).find(params[:id])
    
    theCoordinates = getCoordinatesFromRequest( request )
    @localTeamWatchSites = @team.watch_sites.includes(:venue => :location).near(theCoordinates, 50);
        
    respond_to do |format|
      if (params[:noLayout])
        format.html { render layout: false }
      else
        format.html # show.html.erb
      end
      format.json { render json: @team.to_json(include: [:social_info]) }
    end
  end

  def bing_search_results
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html { render action: "show" }
      format.json { render json: @team.bing_search_results }
    end
  end
  
  def new
    @team = Team.new
    @team.build_location
    @team.build_social_info
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  def edit
    @team = Team.find(params[:id])
    @team.build_social_info unless @team.social_info
  end

  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end
end
