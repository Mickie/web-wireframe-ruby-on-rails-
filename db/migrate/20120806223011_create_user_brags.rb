class CreateUserBrags < ActiveRecord::Migration
  def change
    create_table :user_brags do |t|
      t.references :user
      t.references :brag
      t.integer :type

      t.timestamps
    end
    add_index :user_brags, :user_id
    add_index :user_brags, :brag_id
  end
end
