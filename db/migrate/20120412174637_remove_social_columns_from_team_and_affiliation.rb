class RemoveSocialColumnsFromTeamAndAffiliation < ActiveRecord::Migration
  def up
    remove_column :teams, :twitter_name
    remove_column :teams, :facebook_page_url
    remove_column :teams, :web_url

    remove_column :affiliations, :twitter_name
    remove_column :affiliations, :facebook_page_url
    remove_column :affiliations, :web_url
  end

  def down
    add_column :teams, :twitter_name, :string
    add_column :teams, :facebook_page_url, :string
    add_column :teams, :web_url, :string
    
    Team.all.each do |team|
      team.twitter_name = team.social_info.twitter_name
      team.facebook_page_url = team.social_info.facebook_page_url
      team.web_url = team.social_info.web_url
      team.save
    end

    add_column :affiliations, :twitter_name, :string
    add_column :affiliations, :facebook_page_url, :string
    add_column :affiliations, :web_url, :string

    Affiliation.all.each do |affiliation|
      affiliation.twitter_name = affiliation.social_info.twitter_name
      affiliation.facebook_page_url = affiliation.social_info.facebook_page_url
      affiliation.web_url = affiliation.social_info.web_url
      affiliation.save
    end

  end
end
