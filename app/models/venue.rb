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
  
  def getFoursquareId
    if self.foursquare_id
      return self.foursquare_id
    end
    
    theId = ENV["FANZO_FOURSQUARE_CLIENT_ID"]
    theSecret = ENV["FANZO_FOURSQUARE_CLIENT_SECRET"]
    
    theClient = Foursquare2::Client.new(:client_id => theId, :client_secret => theSecret)
    
    theResponse = theClient.search_venues(ll: "#{self.location.latitude},#{self.location.longitude}", 
                                          query: self.name, 
                                          intent:'match',
                                          v:'20120609')
    theResponse[:venues].each do |aFoursquareVenue|
      if aFoursquareVenue[:location]
        if self.location.isSimilarAddress?(aFoursquareVenue[:location][:address], aFoursquareVenue[:location][:postal_code])
          self.foursquare_id = aFoursquareVenue[:id]
          self.save
          return self.foursquare_id
        end
      end
      
      if aFoursquareVenue[:name]
        if self.isSimilarName? aFoursquareVenue[:name] 
          self.foursquare_id = aFoursquareVenue[:id]
          self.save
          return self.foursquare_id
        end
      end  
    end   
                                       
    return self.foursquare_id
  end
  
  
  def isSimilarName? (aNameToCheck)
    if aNameToCheck == self.name
      return true
    end

    theMatches = 0    
    aNameToCheck.split(" ").each do |aChunk|
      if self.name.include? aChunk
        theMatches += 1
      end
    end
    
    return theMatches > 2
  end
end
