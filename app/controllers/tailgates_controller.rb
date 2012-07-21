class TailgatesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy] 

  # GET /tailgates/search.js
  def search
    @tailgates = Tailgate.includes(:posts).order("posts.updated_at DESC").where(team_id: params[:team_id])

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @tailgates }
      format.js 
    end
  end

  # GET /tailgates
  # GET /tailgates.json
  def index
    if ( params[:filter] == "user" && user_signed_in? )
      @tailgates = current_user.tailgates.includes(:team, :posts => :user)
      @tailgates += current_user.followed_tailgates.includes(:team, :posts => :user)
    else
      thePage = params[:page] ? params[:page] : 1
      @tailgates = Tailgate.includes(:team, :posts => :user).order("posts_updated_at DESC").page(thePage) 
    end
    
    respond_to do |format|
      if (params[:noLayout])
        format.html { render layout: false }
      else
        format.html # index.html.erb
      end
      format.json { render json: @tailgates }
      format.js
    end
  end

  # GET /tailgates/1
  # GET /tailgates/1.json
  def show
    @tailgate = Tailgate.includes(:team, :posts => [ {:comments => :user}, :user ] ).find(params[:id])
    if request.path != tailgate_path(@tailgate)
      return redirect_to @tailgate, status: :moved_permanently
    end    
    
    @post = Post.new(facebook_flag:true)
    @currentCityState = request.location.state_code == "" ? request.location.city : "#{request.location.city}, #{request.location.state_code}"
    
    
    theCoordinates = request.location.coordinates
    if request.remote_ip == "127.0.0.1"
      theCoordinates = "Northwest University, Kirkland WA"
      @currentCityState = "Kirkland, WA"
    end
    
    @localTeamWatchSites = @tailgate.team.watch_sites.includes(:venue => {:location => :state}).near(theCoordinates, 20);

    respond_to do |format|
      if (params[:noLayout])
        format.html { render layout: false }
      else
        format.html # show.html.erb
      end
      format.json { render json: @tailgate }
    end
  end

  # GET /tailgates/new
  # GET /tailgates/new.json
  def new
    @tailgate = current_user.tailgates.build
    @tailgateVenue = @tailgate.tailgate_venues.build

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
    
    if (@tailgate.topic_tags.length == 0 && @tailgate.team)
      if ( @tailgate.team.social_info )
        @tailgate.topic_tags = @tailgate.team.social_info.hash_tags
      else
        @tailgate.topic_tags = "##{@tailgate.team.mascot}"
      end
    end

    @tailgate.topic_tags = cleanupTags(@tailgate.topic_tags)    

    respond_to do |format|
      if (@tailgate.user_id != current_user.id)
        format.html { render action: "new", notice: 'Cannot create a tailgate for another user.' }
        format.json { render json: @tailgate.errors, status: :unprocessable_entity }
        format.js { "alert('Cannot create a tailgate for another user');"}
      elsif @tailgate.save
        format.html { redirect_to @tailgate, notice: 'Tailgate was successfully created.' }
        format.json { render json: @tailgate, status: :created, location: @tailgate }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @tailgate.errors, status: :unprocessable_entity }
        format.js { "alert('There was a problem creating the tailgate');" }
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
    
    if (@tailgate.user_id == current_user.id || admin_signed_in?)
      @tailgate.destroy
    end
    
    respond_to do |format|
      if (@tailgate.user_id != current_user.id && !admin_signed_in?)
        format.html { redirect_to root_path, notice: 'Cannot delete a tailgate owned by another user.' }
        format.json { render json: @tailgate.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to tailgates_url }
        format.json { head :no_content }
      end
    end
  end
  
  def cleanupTags(aTagString)
    theInitialList = aTagString.strip.split(',')
    theNewList = []
    theInitialList.each do |aTag|
      theNewList.push(aTag.strip.gsub(/([^,])\s*? #/, "\\1, #" ).gsub(/([^,])\s*? "/, "\\1, \"" ))
    end
    theNewList.join(', ')
  end
end
