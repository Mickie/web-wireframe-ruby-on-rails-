class CreateWatchSites < ActiveRecord::Migration
  def change
    create_table :watch_sites do |t|
      t.string :name
      t.references :team, null:false
      t.references :venue, null:false

      t.timestamps
    end
    add_index :watch_sites, :team_id
    add_index :watch_sites, :venue_id
  end
end
