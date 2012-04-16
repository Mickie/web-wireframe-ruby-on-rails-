class CreateGameWatches < ActiveRecord::Migration
  def change
    create_table :game_watches do |t|
      t.string :name
      t.references :event
      t.references :venue
      t.references :creator

      t.timestamps
    end
    add_index :game_watches, :event_id
    add_index :game_watches, :venue_id
    add_index :game_watches, :creator_id
  end
end
