class Affiliation < ActiveRecord::Base
  has_many :teams, :inverse_of => :affiliation
  belongs_to :location
  belongs_to :social_info
    
  accepts_nested_attributes_for :location  
  accepts_nested_attributes_for :social_info  
end
