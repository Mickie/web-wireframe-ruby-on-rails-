class AddEspnNameIdToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :espn_team_name_id, :string
  end
end
