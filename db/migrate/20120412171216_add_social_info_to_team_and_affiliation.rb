class AddSocialInfoToTeamAndAffiliation < ActiveRecord::Migration
  def up
    change_table :teams do |t|
      t.references :social_info
    end
    
    change_table :affiliations do |t|
      t.references :social_info
    end
    
    Team.all.each do |team|
      theSocialInfo = SocialInfo.create(twitter_name: team.twitter_name, 
                                        facebook_page_url: team.facebook_page_url,
                                        web_url: team.web_url)
      team.social_info = theSocialInfo
      team.save
    end

    Affiliation.all.each do |affiliation|
      theSocialInfo = SocialInfo.create(twitter_name: affiliation.twitter_name, 
                                        facebook_page_url: affiliation.facebook_page_url,
                                        web_url: affiliation.web_url)
      affiliation.social_info = theSocialInfo
      affiliation.save
    end

  end
  
  def down
    remove_column :team, :social_info
    remove_column :affiliation, :social_info
  end
end
