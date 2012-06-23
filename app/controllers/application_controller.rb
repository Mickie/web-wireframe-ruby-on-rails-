class ApplicationController < ActionController::Base
  protect_from_forgery
  

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
    if resource.is_a?(User)
      root_path
    elsif resource.is_a?(Admin)
      admin_path(resource)
    else
      super
    end
  end  
   
  
end
