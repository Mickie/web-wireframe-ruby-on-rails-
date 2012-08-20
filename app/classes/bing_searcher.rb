class BingSearcher
  
  def updateBingSearchResults()
    Team.visible.each do | aTeam |
      searchForTeamData( aTeam.id )
    end
  end
  
  def searchForTeamData( aTeamId )
    theTeam = Team.find(aTeamId)
    theConnection = Faraday.new('https://api.datamarket.azure.com', ssl:{ ca_path: "/usr/lib/ssl/certs/ca-certificates.crt"})
    theConnection.basic_auth("", "QxHn05Z96oTB5U46PZ/zbJ6hJeSztC2uhhmWDTGK6lQ=")
    
    theResponse = theConnection.get "/Data.ashx/Bing/Search/v1/Composite" do | aRequest |
      aRequest.params["Sources"] = "'web+image+video+news'"
      aRequest.params["Query"] = "'Latest news on #{theTeam.name} #{theTeam.sport.name}'"
      aRequest.params["NewsCategory"] = "'rt_Sports'"
      aRequest.params["$top"] = "25"
      aRequest.params["$format"] = "JSON"
    end

    Rails.logger.info("bing search response for #{theTeam.name}: #{theResponse.status}")
    if (theResponse.status == 200)
      if theTeam.bing_search_results
        theTeam.bing_search_results.search_result = theResponse.body
        theTeam.bing_search_results.save
      else
        theTeam.create_bing_search_results( search_result: theResponse.body )
        theTeam.save
      end
    else
      Rails.logger.error("Failed to load bing search results")
    end
  end
end
