class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.references :home_team, null:false
      t.references :visiting_team, null:false
      t.date :event_date, null:false
      t.time :event_time, null:false
      t.references :location

      t.timestamps
    end
    add_index :events, :home_team_id
    add_index :events, :visiting_team_id
    add_index :events, :location_id
  end
end
