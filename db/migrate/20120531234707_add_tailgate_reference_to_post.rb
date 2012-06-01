class AddTailgateReferenceToPost < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.references :tailgate
    end
  end

  def down
    remove_column :posts, :tailgate_id
  end
end
