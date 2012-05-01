class AddEspnIdAndEspnUrlToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :espn_team_id, :integer
    add_column :teams, :espn_team_url, :string
    add_index :teams, :espn_team_id, :unique => true
  end
end
