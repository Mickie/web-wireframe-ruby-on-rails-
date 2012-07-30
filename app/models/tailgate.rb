require 'sass'

class Tailgate < ActiveRecord::Base
  extend FriendlyId
  include ApplicationHelper
  
  friendly_id :name, use: [:slugged, :history] 
  
  belongs_to :user
  belongs_to :team

  has_many :posts, inverse_of: :tailgate, dependent: :destroy, order: "updated_at DESC"
  
  has_many :tailgate_venues, inverse_of: :tailgate, dependent: :delete_all
  has_many :venues, through: :tailgate_venues 
  
  has_many :tailgate_followers, inverse_of: :tailgate, :dependent => :delete_all
  has_many :followers, through: :tailgate_followers, source: :user
  
  validates :name, presence:true
  validates :team_id, presence:true
  validates :user_id, presence:true
  validates :topic_tags, presence:true

  attr_accessible :name, :team_id, :user_id, :color, :topic_tags, :not_tags, :description
  
  paginates_per 24
  
  def addInitialPost
    theFanzoUser = User.find_by_email("founders@fanzo.me")
    
    if theFanzoUser
      theFanzoTailgate = theFanzoUser.tailgates.find_by_id(15)
      
      if theFanzoTailgate
        theContent = "Hey #{self.user.first_name},\n\tCongratulations on your new fanzone, #{self.name}.  Here are the topic details for later reference: #{self.topic_tags}." +
                      "\n\nYou can find people already talking about your topic in the twitter stream.  Feel free to invite them to your party!" +
                      "\n\nWe hope you enjoy your new tailgate.  If you have any questions, feel free to reach out on The World's Largest Tailgate Party: ( #{getTailgateBitly(theFanzoTailgate)} )." +
                      "\n\nThanks, \nThe Fanzo Team"
        thePost = theFanzoUser.posts.create(tailgate_id: self.id, content: theContent )
      end
    end
  end
  
  def light_color
    theStyle = Sass.compile(".style { color: mix(#FFFFFF, #{color}, 75%);}")
    theStyle.match("color: (.*);")[1]
  end

end
