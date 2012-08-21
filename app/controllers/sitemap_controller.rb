class SitemapController < ApplicationController
  caches_action :show

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