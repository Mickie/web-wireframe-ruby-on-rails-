class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.string :name
      t.references :conference, null:false

      t.timestamps
    end
  end
end
