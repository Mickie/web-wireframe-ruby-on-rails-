class AddSportAssociationToLeague < ActiveRecord::Migration
  def up
    change_table :leagues do |t|
      t.references :sport, null:false
    end
  end
  
  def down
    remove_column :leagues, :sport_id
  end
end
