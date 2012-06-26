class Venue < ActiveRecord::Base
  belongs_to :social_info, :dependent => :destroy
  belongs_to :location, :dependent => :destroy
  belongs_to :venue_type
  
  has_many :game_watches, inverse_of: :venue, :dependent => :delete_all
  has_many :events, through: :game_watches   

  has_many :watch_sites, inverse_of: :venue, :dependent => :delete_all
  has_many :teams, through: :watch_sites   

  has_many :tailgate_venues, inverse_of: :venue, :dependent => :delete_all
  has_many :tailgates, through: :tailgate_venues   

  validates :name, uniqueness:true, presence:true
  validates :venue_type, presence:true

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :social_info
  
  attr_accessible :name, :venue_type_id, :social_info_attributes, :location_attributes
  
  def getFoursquareId
    if self.foursquare_id
      return self.foursquare_id
    end
    
    begin 
      theId = ENV["FANZO_FOURSQUARE_CLIENT_ID"]
      theSecret = ENV["FANZO_FOURSQUARE_CLIENT_SECRET"]
      
      theClient = Foursquare2::Client.new(:client_id => theId, :client_secret => theSecret)
      
      theResponse = theClient.search_venues(ll: "#{self.location.latitude},#{self.location.longitude}", 
                                            query: self.name, 
                                            intent:'match',
                                            v:'20120609')
      
      theId = findMatchingVenue(theResponse[:venues])
      
      if !theId
        theResponse = theClient.search_venues(ll: "#{self.location.latitude},#{self.location.longitude}", 
                                              query: self.name, 
                                              intent:'checkin',
                                              v:'20120609')
        theId = findMatchingVenue(theResponse[:venues])
      end
  
      self.foursquare_id = theId
      self.save
    rescue Exception => e
      Rails.logger.warn "Error getting Foursquare ID: #{e.to_s}"
      return null
    end
                                             
    return theId
  end
  
  def isSimilarName? (aNameToCheck)
    if aNameToCheck == self.name
      return true
    end

    theMatches = 0
    theChunks = aNameToCheck.split(" ")
    theChunks.each do |aChunk|
      if self.name.include? aChunk
        theMatches += 1
      end
    end
    
    if theMatches > (1 + theChunks.length)/2
      return true
    end

    return self.name.include? aNameToCheck    
  end
  
  private
    
    def findMatchingVenue(aListOfVenues)
      aListOfVenues.each do |aFoursquareVenue|
        if aFoursquareVenue[:location] && aFoursquareVenue[:location][:address]
          if self.location.isSimilarAddress?(aFoursquareVenue[:location][:address], aFoursquareVenue[:location][:postalCode])
            return aFoursquareVenue[:id]
          end
        end
        
        if aFoursquareVenue[:name]
          if self.isSimilarName? aFoursquareVenue[:name] 
            return aFoursquareVenue[:id]
          end
        end  
      end
      
      return nil
    end
end
