class FacebookPage < ActiveRecord::Base
  belongs_to :user
  belongs_to :tailgate
  attr_accessible :page_id, :tailgate_id
end
