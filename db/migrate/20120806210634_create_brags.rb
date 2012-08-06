class CreateBrags < ActiveRecord::Migration
  def change
    create_table :brags do |t|
      t.string :content

      t.timestamps
    end
    
    add_index :brags, :content, unique:true
  end
end
