class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.string :name
      t.references :location
      t.string :twitter_name
      t.string :facebook_page_url
      t.string :web_url

      t.timestamps
    end
    add_index :affiliations, :location_id
  end
end
