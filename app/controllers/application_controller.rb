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
   
  def getCoordinatesFromRequest(aRequest)
    if aRequest.remote_ip == "127.0.0.1" || aRequest.remote_ip == "10.0.1.191"
      return "Northwest University, Kirkland WA"
    elsif aRequest.location && aRequest.location.coordinates
      return aRequest.location.coordinates 
    end
    
    return "Space Needle, Seattle WA"
  end

  def getCityStateFromRequest(aRequest)
    
    if aRequest.remote_ip == "127.0.0.1" || aRequest.remote_ip == "10.0.1.191"
      return "Kirkland, WA"
    elsif aRequest.location
      return request.location.state_code == "" ? request.location.city : "#{request.location.city}, #{request.location.state_code}" 
    end
    
    return "Seattle, WA"
  end
  
  def getLocationQueryFromRequestOrUser(aRequest, aUser)
    
    theCurrentCityState = getCityStateFromRequest( aRequest )
    if theCurrentCityState.blank?
      if aUser && !aUser.location.blank?
        theCurrentCityState = aUser.location
      elsif aUser && !aUser.user_locations.empty?
        theCurrentCityState = aUser.user_locations.first.location_query
      else
        theCurrentCityState = "Seattle, WA"
      end
    end
    
    return theCurrentCityState
  end

end
