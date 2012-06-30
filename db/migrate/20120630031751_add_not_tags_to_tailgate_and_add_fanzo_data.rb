class AddNotTagsToTailgateAndAddFanzoData < ActiveRecord::Migration
  def up
    add_column :tailgates, :not_tags, :string, default:""
    remove_column :tailgates, :topic_tags
    add_column :tailgates, :topic_tags, :string, default:""
    
    say "Creating FANZO user"
    
    theFanzoUser = User.new
    theFanzoUser.email = "founders@fanzo.me"
    theFanzoUser.password = "SophieGabbyGator!"
    theFanzoUser.password_confirmation = "SophieGabbyGator!"
    theFanzoUser.first_name = "FANZO"
    theFanzoUser.last_name = "Founders"
    theFanzoUser.name = "FANZO Founders"
    theFanzoUser.image = "http://www.fanzo.me/assets/fanzoProfilePic.png"
    theFanzoUser.description = "This is the official FANZO Founders account"
    theFanzoUser.save
    
    theFanzoLeague = League.new
    theFanzoLeague.name = "FANZO's League"
    theFanzoLeague.sport_id = 1
    theFanzoLeague.visible = false
    theFanzoLeague.save
    
    theFanzoSocialInfo = SocialInfo.new
    theFanzoSocialInfo.twitter_name = "FanzoFans"
    theFanzoSocialInfo.facebook_page_url = "https://www.facebook.com/FanzoFans"
    theFanzoSocialInfo.web_url = "http://www.fanzo.me"
    theFanzoSocialInfo.hash_tags = "#FANZO"
    theFanzoSocialInfo.save
    
    theFanzoLocation = Location.new
    theFanzoLocation.name = "FANZO Headquarters"
    theFanzoLocation.address1 = "State Street"
    theFanzoLocation.city = "Kirkland"
    theFanzoLocation.state_id = 47
    theFanzoLocation.postal_code = "98033"
    theFanzoLocation.save
    
    say "Creating FANZO team"
    theFanzoTeam = Team.new
    theFanzoTeam.name = "FANZO Founders"
    theFanzoTeam.sport_id = 1
    theFanzoTeam.league_id = theFanzoLeague.id
    theFanzoTeam.social_info_id = theFanzoSocialInfo.id
    theFanzoTeam.location_id = theFanzoLocation.id
    theFanzoTeam.slug = "fanzo-founders"
    theFanzoTeam.short_name = "FANZO"
    theFanzoTeam.mascot = "Founders"
    theFanzoTeam.save
    
    say "Creating FANZO tailgate"
    theFanzoTailgate = Tailgate.new
    theFanzoTailgate.name = "The World's Largest Tailgate Party!"
    theFanzoTailgate.user_id = theFanzoUser.id
    theFanzoTailgate.team_id = theFanzoTeam.id
    theFanzoTailgate.official = true
    theFanzoTailgate.color = "#000000"
    theFanzoTailgate.topic_tags = "#FANZO #sports"
    theFanzoTailgate.save
    
    theFanzoPost = theFanzoTailgate.posts.build
    theFanzoPost.content = "Welcome to the world's largest tailgate party!"
    theFanzoPost.user_id = theFanzoUser.id
    theFanzoPost.save  
    
    
    say "Creating official fanzones"
    Team.includes(:social_info).all.each do |aTeam|
      say "Creating tailgate for #{aTeam.name}"
      theTeamTailgate = Tailgate.new
      theTeamTailgate.name = aTeam.name
      theTeamTailgate.user_id = theFanzoUser.id
      theTeamTailgate.team_id = aTeam.id
      theTeamTailgate.color = "#000000"
      theTeamTailgate.official = true
      if aTeam.social_info
        theTeamTailgate.topic_tags = aTeam.social_info.hash_tags
        theTeamTailgate.not_tags = aTeam.social_info.not_tags
      else
        theTeamTailgate.topic_tags = "##{aTeam.mascot}"
        theTeamTailgate.not_tags = ""
      end
      theTeamTailgate.save
      
      theFirstPost = theTeamTailgate.posts.build
      theFirstPost.content = "Welcome to the official tailgate of the #{aTeam.name}!"
      theFirstPost.user_id = theFanzoUser.id
      theFirstPost.save  
    end    
  end
  
  def down
    theFanzoUser = User.find_by_email("founders@fanzo.me")
    theFanzoUser.destroy
    
    theFanzoTeam = Team.find_by_name("FANZO Founders")
    theFanzoTeam.destroy
    
    theFanzoLeague = League.find_by_name("FANZO's League")
    theFanzoLeague.destroy
    
    remove_column :tailgates, :not_tags
    remove_column :tailgates, :topic_tags
    add_colomn :tailgates, :topic_tags, :string
  end
end
