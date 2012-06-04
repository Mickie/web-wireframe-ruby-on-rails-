class AddNotTagsToSocialInfo < ActiveRecord::Migration
  def change
    add_column :social_infos, :not_tags, :string, default:""
  end
end
