class Affiliation < ActiveRecord::Base
  belongs_to :location
  has_many :teams
  
  accepts_nested_attributes_for :location  
end
