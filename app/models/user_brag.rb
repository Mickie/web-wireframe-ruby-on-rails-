class UserBrag < ActiveRecord::Base
  belongs_to :user
  belongs_to :brag
  
  accepts_nested_attributes_for :brag

  attr_accessible :type, :brag_id, :brag_attributes
end
