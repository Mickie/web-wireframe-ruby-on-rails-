class SitemapController < ApplicationController
  caches_action :show, :index
  layout nil

  def index
    if request.host == 'www.fanzo.me'
      render 'allow.txt', :content_type => "text/plain"
    else
      render 'disallow.txt', :content_type => "text/plain"
    end
  end
  
  def show
    @static_paths = [{path: root_path, change_rate: "daily"}, {path: about_path, change_rate: "weekly"}]
    @tailgates = Tailgate.all
    @users = User.all

    headers['Content-Type'] = 'application/xml'
    respond_to do |format|
      format.xml
    end
    
  end
end