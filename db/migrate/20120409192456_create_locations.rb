class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address1, null:false
      t.string :address2
      t.string :city
      t.references :state, null:false
      t.string :postal_code
      t.references :country, null:false, default:1
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :locations, :state_id
    add_index :locations, :country_id
  end
end
