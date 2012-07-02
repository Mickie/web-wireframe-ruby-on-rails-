class Topic < ActiveRecord::Base
  attr_accessible :hash_tags, :not_tags, :name, :visible
  
  validates :name, uniqueness:true
  validates :hash_tags, presence:true
  
  scope :visible, where(visible:true)  
  
end
