class CreateAmazonProductResultsForTeams < ActiveRecord::Migration
  def change
    create_table :amazon_product_results_for_teams do |t|
      t.text :product_result
      t.references :team

      t.timestamps
    end
    add_index :amazon_product_results_for_teams, :team_id
  end
end
