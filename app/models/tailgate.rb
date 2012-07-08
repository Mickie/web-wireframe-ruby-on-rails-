require 'sass'

class Tailgate < ActiveRecord::Base
  extend FriendlyId
  
  friendly_id :name, use: [:slugged, :history] 
  
  belongs_to :user
  belongs_to :team

  has_many :posts, inverse_of: :tailgate, dependent: :destroy, order: "created_at DESC"
  
  has_many :tailgate_venues, inverse_of: :tailgate, dependent: :delete_all
  has_many :venues, through: :tailgate_venues 
  
  has_many :tailgate_followers, inverse_of: :tailgate, :dependent => :delete_all
  has_many :followers, through: :tailgate_followers, source: :user
  
  validates :name, presence:true
  validates :user_id, presence:true
  validates :topic_tags, presence:true

  attr_accessible :name, :team_id, :user_id, :color, :topic_tags, :not_tags
  
  paginates_per 24
  
  def light_color
    theStyle = Sass.compile(".style { color: mix(#FFFFFF, #{color}, 75%);}")
    theStyle.match("color: (.*);")[1]
  end

end
