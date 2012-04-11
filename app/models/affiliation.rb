class Affiliation < ActiveRecord::Base
  belongs_to :location
  has_many :teams, :inverse_of => :affiliation
    
  accepts_nested_attributes_for :location  
end
