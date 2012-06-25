class QuickTweet < ActiveRecord::Base
  belongs_to :sport
  
  validates :name, presence:true
  validates :tweet, presence:true
  validates :sport_id, presence:true
  
  attr_accessible :name, :tweet, :sport_id, :happy
end
