class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, unique:true
      t.string :abbreviation, limit:3, unique:true
      
      t.timestamps
    end
  end
end
