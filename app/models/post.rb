class Post < ActiveRecord::Base
  belongs_to :tailgate
  belongs_to :user
  
  has_many :comments, inverse_of: :post, :dependent => :delete_all, order: "created_at"
  
  validates :user, :tailgate, presence:true
  
  attr_accessible :content, 
                  :tailgate_id, 
                  :user_id, 
                  :twitter_id, 
                  :twitter_flag, 
                  :twitter_reply_id, 
                  :twitter_retweet_id, 
                  :facebook_flag, 
                  :facebook_id
end
