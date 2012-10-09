require 'vacuum'
require 'json'

class AmazonProductFinder
  
  def updateAmazonProductResults()
    Team.visible.each do | aTeam |
      searchForTeamData( aTeam.id )
      sleep 2
    end
    
    updateFanzoFounders()
  end
  
  def updateFanzoFounders
    theTeam = Team.find_by_name("FANZO Founders")
    theQuery = "'Football Tailgate'"
    theResponse = getAmazonResultsForQuery( theQuery )
    saveResponseToTeam( theResponse, theTeam )
  end
  
  def searchForTeamData( aTeamId )
    theTeam = Team.find(aTeamId)
    theQuery = "'#{theTeam.name} #{theTeam.sport.name}'"
    theResponse = getAmazonResultsForQuery( theQuery )
    saveResponseToTeam( theResponse, theTeam )
  end
  
  def getAmazonResultsForQuery( aQuery )
    begin
      Rails.logger.info("getAmazonResultsForQuery #{aQuery}")
      theRequest = Vacuum.new 
  
      theRequest.configure  key: ENV["AWS_ACCESS_KEY_ID"],
        secret: ENV["AWS_SECRET_ACCESS_KEY"],
        tag: ENV["AWS_ASSOCIATE_TAG"]

      theResponse = theRequest.get query: { 'Operation'   => 'ItemSearch',
                       'SearchIndex' => 'All',
                       'ResponseGroup' => 'Images,ItemAttributes',
                       'Keywords'    => aQuery }

    rescue Exception => e
      Rails.logger.error("amazon product exception:  #{e.to_s}")
    end      
  end

  def saveResponseToTeam( aResponse, aTeam )
    Rails.logger.info("ammazon product response for #{aTeam.name}: #{aResponse.status}")
    if (aResponse.status == 200)
      json = Hash.from_xml(aResponse.body).to_json

      if aTeam.amazon_product_results
        aTeam.amazon_product_results.product_result = json
        aTeam.amazon_product_results.save
      else
        aTeam.create_amazon_product_results( product_result: json )
        aTeam.save
      end
    else
      Rails.logger.error("Failed to load amazon product results for team: #{aTeam.name}")
    end
  end

end
