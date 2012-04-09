class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null:false
      t.references :sport, null:false
      t.references :league, null:false
      t.references :division
      t.references :conference
      t.references :location, null:false
      t.string :twitter_name
      t.string :facebook_page_url
      t.string :web_url

      t.timestamps
    end
    add_index :teams, :sport_id
    add_index :teams, :league_id
    add_index :teams, :division_id
    add_index :teams, :conference_id
    add_index :teams, :location_id
  end
end
