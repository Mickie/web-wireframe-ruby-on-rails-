class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name, null:false, unique:true
      t.references :social_info
      t.references :location
      t.references :venue_type

      t.timestamps
    end
    add_index :venues, :social_info_id
    add_index :venues, :location_id
    add_index :venues, :venue_type_id
  end
end
