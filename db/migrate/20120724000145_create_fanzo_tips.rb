class CreateFanzoTips < ActiveRecord::Migration
  def change
    create_table :fanzo_tips do |t|
      t.string :name, null:false
      t.text :content, null:false

      t.timestamps
    end
  end
end
