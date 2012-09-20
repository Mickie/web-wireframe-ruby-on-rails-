class Post < ActiveRecord::Base
  belongs_to :tailgate, touch: :posts_updated_at
  belongs_to :user
  belongs_to :photo
  
  has_many :comments, inverse_of: :post, dependent: :destroy, order: "created_at"
  
  has_many :user_post_votes, inverse_of: :post, dependent: :delete_all
  
  validates :user, :tailgate, presence:true
  
  accepts_nested_attributes_for :photo
  
  attr_accessible :content, 
                  :tailgate_id, 
                  :user_id, 
                  :twitter_id, 
                  :twitter_flag, 
                  :twitter_reply_id, 
                  :twitter_retweet_id, 
                  :facebook_flag, 
                  :facebook_id,
                  :image_url,
                  :video_id,
                  :photo_attributes

  scope :visible, where("fan_score > -3")  
  
  paginates_per 10
  
  def photo_url
    photo ? photo.image.url : nil
  end
                  
  def shortened_content
    if (self.content.length < 120)
      return self.content
    end
    
    return self.content[0, 116] + "..."
  end                  
end
