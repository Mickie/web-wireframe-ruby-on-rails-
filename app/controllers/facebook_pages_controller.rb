class FacebookPagesController < ApplicationController
  before_filter :authenticate_user!, only: [:show, :new, :edit, :create, :update] 
  before_filter :authenticate_admin!, only: [:index, :destroy] 
  layout false, except: [:index]

  # GET /facebook_pages
  # GET /facebook_pages.json
  def index
    @facebook_pages = FacebookPage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @facebook_pages }
    end
  end

  # GET /facebook_pages/1
  def show
    @facebook_page = FacebookPage.find(params[:id])

    @tailgate = Tailgate.includes(:user, :team, :posts => [ {:comments => :user}, :user ] ).find(@facebook_page.tailgate_id)
    @currentCityState = getLocationQueryFromRequestOrUser( request, current_user )
    @post = Post.new
    @post.build_photo
    @localTeamWatchSites = @tailgate.team.watch_sites.includes(:venue => {:location => :state}).near(@currentCityState, 50);

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /facebook_pages/new
  def new
    @facebook_page = FacebookPage.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /facebook_pages/1/edit
  def edit
    @facebook_page = FacebookPage.find(params[:id])
  end

  # POST /facebook_pages
  def create
    @facebook_page = FacebookPage.new(params[:facebook_page])
    @facebook_page.user_id = current_user.id
    @facebook_page.tailgate = Tailgate.where(official:true).find_by_team_id(params[:team_id])

    respond_to do |format|
      if @facebook_page.save
        format.html { redirect_to @facebook_page, notice: 'Fanzo Facebook page tab was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /facebook_pages/1
  def update
    @facebook_page = FacebookPage.find(params[:id])

    respond_to do |format|
      if @facebook_page.update_attributes(params[:facebook_page])
        format.html { redirect_to @facebook_page, notice: 'Facebook page was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /facebook_pages/1
  def destroy
    @facebook_page = FacebookPage.find(params[:id])
    @facebook_page.destroy

    respond_to do |format|
      format.html { redirect_to facebook_pages_url }
    end
  end
end
