class AddYouTubeChannelToSocialInfo < ActiveRecord::Migration
  def change
    add_column :social_infos, :youtube_url, :string

  end
end
