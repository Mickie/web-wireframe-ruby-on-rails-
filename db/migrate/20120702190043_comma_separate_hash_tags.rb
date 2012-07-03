class CommaSeparateHashTags < ActiveRecord::Migration
  def up
    say "fixing busted topic tags"
    Tailgate.includes(:team).where("teams.social_info_id is null").each do |aTailgate|
      say "fixing: #{aTailgate.name}"
      if aTailgate.team.mascot.include?(" ")
        aTailgate.topic_tags = "\"#{aTailgate.team.mascot}\""
      else
        aTailgate.topic_tags = "##{aTailgate.team.mascot}"
      end
      aTailgate.save
    end
    
    Tailgate.where(topic_tags:nil).each do |aTailgate|
      aTailgate.topic_tags = aTailgate.team.social_info.hash_tags
      aTailgate.save
    end
    
    say "changing to comma separated tags"
    Tailgate.all.each do |aTailgate|
      say "updating tailgate: #{aTailgate.name}"
      aTailgate.topic_tags = aTailgate.topic_tags.split(" #").join(", #")
      aTailgate.not_tags = aTailgate.not_tags.split(" #").join(", #")
      aTailgate.save
    end

    SocialInfo.all.each do |aSocialInfo|
      aSocialInfo.hash_tags = aSocialInfo.hash_tags.split(" #").join(", #") if aSocialInfo.hash_tags
      aSocialInfo.not_tags = aSocialInfo.not_tags.split(" #").join(", #") if aSocialInfo.not_tags
      aSocialInfo.save 
    end    
  end

  def down
  end
end
