class StaticPagesController < ApplicationController
  def home
    @tailgates = Tailgate.includes(:team, :posts => :user).order("posts_updated_at DESC").page(1)
    @device = params[:device]
    
    if browser.mobile? && !browser.tablet?
      render :phone, layout: false
    end
  end

  def about
  end
  
  def channel
    cache_expire = 1.year
    response.headers["Pragma"] = "public"
    response.headers["Cache-Control"] = "max-age=#{cache_expire.to_i}"
    response.headers["Expires"] = (Time.now + cache_expire).strftime("%d %m %Y %H:%I:%S %Z")
    respond_to do |format|
      format.html { render :layout => false, :inline => "<script src='//connect.facebook.net/en_US/all.js'></script>" }
    end
        
  end
end
