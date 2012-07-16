class Post < ActiveRecord::Base
  belongs_to :tailgate, touch: :posts_updated_at
  belongs_to :user
  
  has_many :comments, inverse_of: :post, dependent: :destroy, order: "created_at"
  
  has_many :user_post_votes, inverse_of: :post, dependent: :delete_all
  
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

  scope :visible, where("fan_score > -3")  
                  
  def shortened_content
    if (self.content.length < 120)
      return self.content
    end
    
    return self.content[0, 116] + "..."
  end                  
end
