class Tailgate < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  has_many :posts, inverse_of: :tailgate, dependent: :delete_all, order: "created_at DESC"
  
  has_many :tailgate_venues, inverse_of: :tailgate, :dependent => :delete_all
  has_many :venues, through: :tailgate_venues 
  
  has_many :tailgate_followers, inverse_of: :tailgate, :dependent => :delete_all
  has_many :followers, through: :tailgate_followers, source: :user
  
  validates :name, presence:true
  validates :user_id, presence:true

  attr_accessible :name, :team_id, :user_id

end
