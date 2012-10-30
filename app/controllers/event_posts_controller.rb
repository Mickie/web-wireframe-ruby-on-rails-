class EventPostsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy] 
  before_filter :load_event


  # GET /event_posts
  # GET /event_posts.json
  def index
    @event_posts = EventPost.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_posts }
    end
  end

  # GET /event_posts/1
  # GET /event_posts/1.json
  def show
    @event_post = EventPost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_post }
    end
  end

  # GET /event_posts/new
  # GET /event_posts/new.json
  def new
    @event_post = @event.event_posts.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_post }
    end
  end

  # GET /event_posts/1/edit
  def edit
    @event_post = EventPost.find(params[:id])
  end

  # POST /event_posts
  # POST /event_posts.json
  def create
    @event_post = @event.event_posts.new(params[:event_post])

    if @event_post.visiting_flag
      theVisitingTailgate = Tailgate.where(official:true).find_by_team_id(@event.visiting_team.id)
      @event_post.visiting_post = theVisitingTailgate.posts.new(params[:post])
      @event_post.visiting_post.user = current_user
    end
    
    if @event_post.home_flag
      theHomeTailgate = Tailgate.where(official:true).find_by_team_id(@event.home_team.id)
      @event_post.home_post = theHomeTailgate.posts.new(params[:post])
      @event_post.home_post.user = current_user
    end

    respond_to do |format|
      if @event_post.save

        if @event_post.home_post && current_user.id != theHomeTailgate.user_id
          UserMailer.delay.new_fanzone_post(@event_post.home_post.id) unless theHomeTailgate.user.no_email_on_posts
        end
        
        if @event_post.visiting_post && current_user.id != theVisitingTailgate.user_id
          UserMailer.delay.new_fanzone_post(@event_post.visiting_post.id) unless theVisitingTailgate.user.no_email_on_posts
        end

        SocialSender.new.delay.shareEventPost(@event_post.id)

        format.html { redirect_to @event, notice: 'Event post was successfully created.' }
        format.json { render json: @event_post, status: :created, location: @event_post }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @event_post.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /event_posts/1
  # PUT /event_posts/1.json
  def update
    @event_post = @event.event_posts.find(params[:id])

    respond_to do |format|
      if @event_post.update_attributes(params[:event_post])
        
        if @event_post.home_flag
          if !@event_post.home_post
            theHomeTailgate = Tailgate.where(official:true).find_by_team_id(@event.home_team.id)
            @event_post.home_post = theHomeTailgate.posts.new(params[:post])
            @event_post.home_post.user = current_user
          else
            @event_post.home_post.update_attributes(params[:post])
          end
        elsif @event_post.home_post
          @event_post.home_post.destroy
        end
        
        if @event_post.visiting_flag
          if !@event_post.visiting_post
            theVisitingTailgate = Tailgate.where(official:true).find_by_team_id(@event.visiting_team.id)
            @event_post.visiting_post = theVisitingTailgate.posts.new(params[:post])
            @event_post.visiting_post.user = current_user
          else
            @event_post.visiting_post.update_attributes(params[:post])
          end
        elsif @event_post.visiting_post
          @event_post.visiting_post.destroy
        end
        
        @event_post.save

        format.html { redirect_to @event, notice: 'Event post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_posts/1
  # DELETE /event_posts/1.json
  def destroy
    @event_post = EventPost.find(params[:id])
    @event_post.destroy

    respond_to do |format|
      format.html { redirect_to @event }
      format.json { head :no_content }
    end
  end
  
  def load_event
    @event = Event.find(params[:event_id])
  end
  
end
