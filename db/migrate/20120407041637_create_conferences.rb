class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.references :league, null:false

      t.timestamps
    end
  end
end
