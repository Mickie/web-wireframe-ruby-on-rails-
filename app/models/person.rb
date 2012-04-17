class Person < ActiveRecord::Base
  belongs_to :social_info
  belongs_to :team
  validates :first_name, presence:true
  validates :last_name, presence:true
end
