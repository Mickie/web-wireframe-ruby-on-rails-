class CreateSocialInfos < ActiveRecord::Migration
  def change
    create_table :social_infos do |t|
      t.string :twitter_name
      t.string :facebook_page_url
      t.string :web_url

      t.timestamps
    end
  end
end
