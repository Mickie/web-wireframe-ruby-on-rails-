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
