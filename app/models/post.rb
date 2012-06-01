class Post < ActiveRecord::Base
  belongs_to :tailgate
  
  has_many :comments, inverse_of: :post, :dependent => :delete_all
  
  attr_accessible :content, :title, :tailgate, :tailgate_id
end
