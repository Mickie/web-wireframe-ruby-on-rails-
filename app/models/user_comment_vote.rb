class UserCommentVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  
  validates :user, :comment, presence:true
  
  attr_accessible :up_vote, :comment_id
end
