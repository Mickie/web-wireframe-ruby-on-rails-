class TailgateFollower < ActiveRecord::Base
  belongs_to :user
  belongs_to :tailgate, counter_cache: true

  validates :user_id, presence: true  
  validates :tailgate_id, presence: true
  
  attr_accessible :tailgate_id
end
