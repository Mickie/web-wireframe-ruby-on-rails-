class CreateFunFacts < ActiveRecord::Migration
  def change
    create_table :fun_facts do |t|
      t.string :name, null:false
      t.text :content, null:false

      t.timestamps
    end
  end
end
