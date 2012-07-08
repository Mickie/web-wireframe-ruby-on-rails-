class AddSlugToTailgate < ActiveRecord::Migration
  def up
    add_column :tailgates, :slug, :string, unique:true
    add_index :tailgates, :slug
    
    Tailgate.find_each(&:save)
  end
  
  def down
    remove_index :tailgates, :slug
    remove_column :tailgates, :slug
  end
end
