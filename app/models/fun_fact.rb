class FunFact < ActiveRecord::Base
  attr_accessible :content, :name
  
  validates :content, :name, presence:true
end
