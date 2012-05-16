class StaticPagesController < ApplicationController
  def index
  end

  def about
  end

  def contact
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
