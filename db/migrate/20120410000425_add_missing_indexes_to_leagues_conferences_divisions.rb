class AddMissingIndexesToLeaguesConferencesDivisions < ActiveRecord::Migration
  def change
    add_index :leagues, :sport_id
    add_index :conferences, :league_id
    add_index :divisions, :league_id
  end
end
