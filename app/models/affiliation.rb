class Affiliation < ActiveRecord::Base
  has_many :teams, :inverse_of => :affiliation
  belongs_to :location, :dependent => :destroy
  belongs_to :social_info, :dependent => :destroy
  
  validates :name, uniqueness:true, presence:true
  validates_associated :teams
  
  accepts_nested_attributes_for :location  
  accepts_nested_attributes_for :social_info
  
  attr_accessible :name, :social_info_attributes, :location_attributes
end
