class CreateFacebookPages < ActiveRecord::Migration
  def change
    create_table :facebook_pages do |t|
      t.string :page_id
      t.references :user
      t.references :tailgate

      t.timestamps
    end
    add_index :facebook_pages, :user_id
    add_index :facebook_pages, :tailgate_id
  end
end
