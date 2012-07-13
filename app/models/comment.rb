class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  attr_accessible :content, :user_id, :post_id 

  scope :visible, where("fan_score > -3")  

end
