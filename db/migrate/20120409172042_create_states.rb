class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name, unique:true
      t.string :abbreviation, limit:3, unique:true

      t.timestamps
    end
    
  end
end
