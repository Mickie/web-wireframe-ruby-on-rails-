class CreateTailgates < ActiveRecord::Migration
  def change
    create_table :tailgates do |t|
      t.string :name
      t.references :user
      t.references :team

      t.timestamps
    end
    add_index :tailgates, :user_id
    add_index :tailgates, :team_id
  end
end
