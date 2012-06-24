class CreateTailgateFollowers < ActiveRecord::Migration
  def change
    create_table :tailgate_followers do |t|
      t.references :user
      t.references :tailgate

      t.timestamps
    end
    add_index :tailgate_followers, :user_id
    add_index :tailgate_followers, :tailgate_id
    add_index :tailgate_followers, [:tailgate_id, :user_id], unique:true
  end
end
