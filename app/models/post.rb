class Post < ActiveRecord::Base
  belongs_to :tailgate
  attr_accessible :content, :title, :tailgate, :tailgate_id
end
