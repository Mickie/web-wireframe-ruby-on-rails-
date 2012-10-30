class EventsController < ApplicationController
  before_filter :authenticate_admin!, except: [:index, :show, :addPost]
  before_filter :authenticate_user!, only: [:index, :show, :addPost] 

  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @homeTailgate = Tailgate.where(official:true).find_by_team_id(@event.home_team.id)    
    @visitingTailgate = Tailgate.where(official:true).find_by_team_id(@event.visiting_team.id)
    @post = Post.new
    @post.build_photo
    @event_post = @event.event_posts.build

    if current_user.mine_or_following? @homeTailgate
      @tailgate = @homeTailgate
    else
      @tailgate = @visitingTailgate
    end
    
    #@currentCityState = getLocationQueryFromRequestOrUser( request, current_user )
    #@localHomeTeamWatchSites = @event.home_team.watch_sites.includes(:venue => {:location => :state}).near(@currentCityState, 60);
    #@localVisitingTeamWatchSites =  @event.visiting_team.watch_sites.includes(:venue => {:location => :state}).near(@currentCityState, 60);
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end
  
  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    @event.build_location

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @event.build_location unless @event.location
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
