class Person < ActiveRecord::Base
  belongs_to :social_info, :dependent => :destroy
  belongs_to :team
  
  validates :first_name, presence:true
  validates :last_name, presence:true
  
  accepts_nested_attributes_for :social_info  
  
  def name
     "#{first_name} #{last_name}" 
  end
  
  attr_accessible :first_name, :last_name, :type, :position, :home_town, :home_school, :social_info_id, :social_info_attributes, :team_id
end
