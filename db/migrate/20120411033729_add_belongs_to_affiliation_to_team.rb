class AddBelongsToAffiliationToTeam < ActiveRecord::Migration
  def up
    change_table :teams do |t|
      t.references :affiliation
    end
    add_index :teams, :affiliation_id

  end
  
  def down
    remove_index :teams, :affiliation_id
    
    change_table :teams do |t|
      t.remove :affiliation_id
    end
  end
end
