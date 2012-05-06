class AddSlugToTeam < ActiveRecord::Migration
  def up
    add_column :teams, :slug, :string

    Team.all.each do |team|
      theSlugRegEx = /http:\/\/espn.go.com\/college-football\/team\/_\/id\/(\d+)\/(.*)$/
      theMatches = theSlugRegEx.match(team.espn_team_url) 
      team.slug = theMatches[2]
      team.save
    end

  end
  
  def down

    remove_column :teams, :slug

  end
end
