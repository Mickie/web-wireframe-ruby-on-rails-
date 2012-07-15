class UserPostVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  validates :user, :post, presence:true
  
  attr_accessible :up_vote, :post_id
end
