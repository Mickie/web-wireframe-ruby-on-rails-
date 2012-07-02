class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name, unique:true
      t.string :hash_tags
      t.string :not_tags, default: ""
      t.boolean :visible, default:false

      t.timestamps
    end
  end
end
