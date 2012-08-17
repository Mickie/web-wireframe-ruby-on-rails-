class CreateBingSearchResultsForTeams < ActiveRecord::Migration
  def change
    create_table :bing_search_results_for_teams do |t|
      t.text :search_result
      t.references :team

      t.timestamps
    end
    add_index :bing_search_results_for_teams, :team_id
  end
end
