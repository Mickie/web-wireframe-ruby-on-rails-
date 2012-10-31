class User < ActiveRecord::Base
  extend FriendlyId
  include Bitfields
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  friendly_id :full_name, use: :slugged

  has_many :user_teams, inverse_of: :user, dependent: :delete_all
  has_many :teams, through: :user_teams
  
  has_many :user_locations, inverse_of: :user, dependent: :destroy

  has_many :user_teams, inverse_of: :user, dependent: :delete_all
  has_many :teams, through: :user_teams
  
  has_many :i_was_there_brags, inverse_of: :user, dependent: :delete_all
  has_many :i_watched_brags, inverse_of: :user, dependent: :delete_all
  has_many :i_wish_brags, inverse_of: :user, dependent: :delete_all
  
  has_many :tailgates, inverse_of: :user, dependent: :destroy, order:"posts_updated_at DESC"
  
  has_many :tailgate_followers, inverse_of: :user, dependent: :delete_all
  has_many :followed_tailgates, through: :tailgate_followers, source: :tailgate, order:"posts_updated_at DESC" 
  
  has_many :posts, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy
  
  has_many :user_post_votes, inverse_of: :user, dependent: :delete_all
  has_many :user_comment_votes, inverse_of: :user, dependent: :delete_all

  bitfield :email_bit_flags, 1 => :no_email_on_posts, 
                             2 => :no_email_on_comments, 
                             4 => :no_email_newsletter, 
                             8 => :no_email_on_follows, 
                             16 => :no_email_summary_of_followed_tailgates,
                             32 => :no_fb_share_on_create_tailgate,
                             64 => :no_fb_share_on_follow_tailgate

  attr_accessible :email,
                  :first_name,
                  :last_name,
                  :image,
                  :description,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :twitter_user_id,
                  :twitter_username,
                  :twitter_user_token,
                  :twitter_user_secret,
                  :facebook_user_id,
                  :facebook_access_token,
                  :foursquare_user_id,
                  :foursquare_access_token,
                  :instagram_user_id,
                  :instagram_user_token,
                  :instagram_username,
                  :no_email_on_posts,
                  :no_email_on_comments,
                  :no_email_newsletter,
                  :no_email_on_follows,
                  :no_email_summary_of_followed_tailgates,
                  :no_fb_share_on_create_tailgate,
                  :no_fb_share_on_follow_tailgate
                  
  geocoded_by :location_or_hometown
  after_validation :geocode, :if => :location_or_hometown_changed?
  
  def location_or_hometown
    location || hometown
  end
  
  def location_or_hometown_changed?
    return location_changed? || hometown_changed?
  end
                   
                  
  def isConnectedToTwitter?
    return twitter_user_token? && twitter_user_secret?
  end
  
  def followDefaultTailgate
    theDefaultTailgate = Tailgate.find_by_name("The World's Largest Tailgate Party!")
    if (theDefaultTailgate)
      follow!(theDefaultTailgate)
    end
  end
  
  def getShortenedLocationQuery( aLongLocationQuery )
    theParts = aLongLocationQuery.split(",")
    if theParts.length > 1
      theStateString = theParts[1]
      theStateString.strip!
      theState = State.find_by_name(theStateString)
      if theState
        return "#{theParts[0]}, #{theState.abbreviation}"
      end
    end
    
    return aLongLocationQuery
  end
  
  def updateFromFacebook( aDataJsonString )
    theData = JSON.parse(aDataJsonString)
    if (theData["hometown"] && theData["hometown"]["name"] && theData["hometown"]["name"] != self.hometown)
      self.hometown = getShortenedLocationQuery( theData["hometown"]["name"] )
      self.user_locations.create(location_query: self.hometown)
    end

    if (theData["location"] && theData["location"]["name"] && theData["location"]["name"] != self.location)
      self.location = getShortenedLocationQuery( theData["location"]["name"] )
      self.user_locations.create(location_query: self.location)
    end
    
    if (theData["favorite_teams"])
      theData["favorite_teams"].each do |aTeam|
        if (aTeam["name"])
          theTeam = Team.find_by_name(aTeam["name"])
          if (theTeam && self.teams.find_by_id(theTeam.id) == nil)
            self.teams.push(theTeam)
          end
        end
      end
    end

    self.save
  end
  
  def full_name
    if name && name.length > 0
      return name
    elsif ( first_name && first_name.length > 0 ) && ( last_name && last_name.length > 0)
      return "#{first_name} #{last_name}"
    elsif ( first_name && first_name.length > 0 ) && !( last_name && last_name.length > 0)
      return first_name
    elsif !( first_name && first_name.length > 0 ) && ( last_name && last_name.length > 0)
      return last_name
    elsif twitter_username && twitter_username.length > 0 
      return twitter_username
    elsif twitter_username && twitter_username.length > 0 
      return twitter_username
    elsif instagram_username && instagram_username.length > 0 
      return instagram_username
    else
      return email
    end 
  end
  
  def mine?( aTailgate )
    tailgates.include?( aTailgate )
  end
  
  def following?( aTailgate )
    aTailgate.followers.include?(self)
  end

  def mine_or_following?( aTailgate )
    mine?(aTailgate) || following?( aTailgate )
  end

  def follow!( aTailgate )
    tailgate_followers.create!( tailgate_id: aTailgate.id)
  end  

  def unfollow!( aTailgate )
    tailgate_followers.find_by_tailgate_id( aTailgate.id ).destroy
  end
  
  def myFanzones
    tailgates.all + followed_tailgates.all
  end
  
  def large_profile_pic( aWidth, aHeight )
    "https://graph.facebook.com/#{facebook_user_id}/picture?type=large&width=#{aWidth}&height=#{aHeight}"
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end  
end


