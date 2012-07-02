class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name, unique:true
      t.string :hash_tags
      t.string :not_tags
      t.boolean :visible, default:false

      t.timestamps
    end
  end
end
