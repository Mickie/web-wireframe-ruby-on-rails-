class Person < ActiveRecord::Base
  belongs_to :social_info
  belongs_to :team
  validates :first_name, presence:true
  validates :last_name, presence:true
  
  accepts_nested_attributes_for :social_info  
  
  def name
     "#{first_name} #{last_name}"   
  end
end
