class AddColorOfficialFlagAndTopicTagsToTailgate < ActiveRecord::Migration
  def change
    add_column :tailgates, :color, :string, default:"#002A5C"
    add_column :tailgates, :official, :boolean, default:false
    add_column :tailgates, :topic_tags, :string
    
    Tailgate.all.each do |aTailgate|
      say "migrating: " + aTailgate.name
      aTailgate.topic_tags = aTailgate.team.social_info.hash_tags
      aTailgate.save 
    end
  end
end
