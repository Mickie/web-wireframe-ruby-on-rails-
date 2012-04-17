class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name, null:false
      t.string :last_name, null:false
      t.string :home_town
      t.string :home_school
      t.string :position
      t.string :type
      t.references :social_info
      t.references :team

      t.timestamps
    end
    add_index :people, :social_info_id
    add_index :people, :team_id
  end
end
