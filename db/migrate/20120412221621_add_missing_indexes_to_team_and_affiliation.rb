class AddMissingIndexesToTeamAndAffiliation < ActiveRecord::Migration
  def change
    add_index :affiliations, :social_info_id
    add_index :teams, :social_info_id
  end
end
