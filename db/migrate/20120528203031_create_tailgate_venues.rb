class CreateTailgateVenues < ActiveRecord::Migration
  def change
    create_table :tailgate_venues do |t|
      t.references :tailgate
      t.references :venue
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :tailgate_venues, :tailgate_id
    add_index :tailgate_venues, :venue_id
  end
end
