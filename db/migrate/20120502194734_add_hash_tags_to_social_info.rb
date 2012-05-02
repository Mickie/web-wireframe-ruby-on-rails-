class AddHashTagsToSocialInfo < ActiveRecord::Migration
  def change
    add_column :social_infos, :hash_tags, :string

  end
end
