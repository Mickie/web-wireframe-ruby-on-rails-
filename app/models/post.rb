class Post < ActiveRecord::Base
  belongs_to :tailgate
  belongs_to :user
  
  has_many :comments, inverse_of: :post, :dependent => :delete_all
  
  validates :user, :tailgate, presence:true
  
  attr_accessible :content, :title, :tailgate_id, :user_id
end
