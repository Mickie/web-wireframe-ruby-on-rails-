class Post < ActiveRecord::Base
  belongs_to :tailgate, touch: :posts_updated_at
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

  scope :visible, where("fan_score > -3")  
                  
  def shortened_content
    if (self.content.length < 120)
      return self.content
    end
    
    return self.content[0, 116] + "..."
  end                  
end
