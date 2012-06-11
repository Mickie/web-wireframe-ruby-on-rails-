class Location < ActiveRecord::Base
  belongs_to :state
  belongs_to :country

  geocoded_by :one_line_address
  after_validation :geocode, :if => :one_line_address_changed?
  
  def one_line_address
    "#{address1}, #{address2}#{address2 && !address2.empty? ? ", " : ""}#{city}, #{state.abbreviation} #{postal_code}"
  end
  
  def one_line_address_changed?
    return address1_changed? || address2_changed? || city_changed? || state.changed? || postal_code_changed?
  end
  
  def isSimilarAddress?(aStreetAddress, aPostalCode)
    if aPostalCode != self.postal_code
      return false
    end
    
    theListOfAddressChunks = aStreetAddress.split(' ')
    
    if (sameHouseNumber? theListOfAddressChunks[0])
      return true
    end

    return isAddressClose? theListOfAddressChunks    
  end
  
  private
  
  def sameHouseNumber?(aHouseNumber)
    return address1.include? aHouseNumber
  end
  
  def isAddressClose?(aListOfAddressChunks)
    theMatches = 0
    theFullAddress = one_line_address
    aListOfAddressChunks.each do |aChunk|
      if theFullAddress.include? aChunk
        theMatches+=1
      end
    end
    return theMatches > 1
  end
end
