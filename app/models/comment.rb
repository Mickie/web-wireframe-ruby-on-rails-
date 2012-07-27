class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, touch: :comments_updated_at

  has_many :user_comment_votes, inverse_of: :comment, dependent: :delete_all
  
  validates :user, :post, presence:true

  attr_accessible :content, :user_id, :post_id 

  scope :visible, where("fan_score > -3")  

end
