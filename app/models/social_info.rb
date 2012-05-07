class SocialInfo < ActiveRecord::Base
  
  attr_accessible :twitter_name, :facebook_page_url, :web_url, :hash_tags, :youtube_url
end
