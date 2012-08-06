class UserBrag < ActiveRecord::Base
  belongs_to :user
  belongs_to :brag
  attr_accessible :type, :brag_id
  
  accepts_nested_attributes_for :brag
end
