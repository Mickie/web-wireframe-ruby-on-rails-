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
end
