class BingSearcher
  
  def updateBingSearchResults()
    Team.visible.each do | aTeam |
      searchForTeamData( aTeam.id )
    end
    
    updateFanzoFounders()
  end
  
  def updateFanzoFounders
    theTeam = Team.find_by_name("Fanzo Founders")
    theQuery = "'Latest Football Tailgate news'"
    theResponse = getBingResultsForQuery( theQuery )
    saveResponseToTeam( theResponse, theTeam )
  end
  
  def searchForTeamData( aTeamId )
    theTeam = Team.find(aTeamId)
    theQuery = "'Latest news on #{theTeam.name} #{theTeam.sport.name}'"
    theResponse = getBingResultsForQuery( theQuery )
    saveResponseToTeam( theResponse, theTeam )
  end
  
  def getBingResultsForQuery( aQuery )
    
    theConnection = Faraday.new('https://api.datamarket.azure.com', ssl:{ ca_path: "/usr/lib/ssl/certs/ca-certificates.crt"})
    theConnection.basic_auth("", ENV["FANZO_BING_KEY"])
    
    theResponse = theConnection.get "/Data.ashx/Bing/Search/v1/Composite" do | aRequest |
      aRequest.params["Sources"] = "'web+image+video+news'"
      aRequest.params["Query"] = aQuery
      aRequest.params["NewsCategory"] = "'rt_Sports'"
      aRequest.params["$top"] = "25"
      aRequest.params["$format"] = "JSON"
    end
  end

  def saveResponseToTeam( aResponse, aTeam )
    Rails.logger.info("bing search response for #{aTeam.name}: #{aResponse.status}")
    if (aResponse.status == 200)
      if aTeam.bing_search_results
        aTeam.bing_search_results.search_result = aResponse.body
        aTeam.bing_search_results.save
      else
        aTeam.create_bing_search_results( search_result: aResponse.body )
        aTeam.save
      end
    else
      Rails.logger.error("Failed to load bing search results for team: #{aTeam.name}")
    end
  end

end
