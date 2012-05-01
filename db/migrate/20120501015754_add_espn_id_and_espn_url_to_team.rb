class AddEspnIdAndEspnUrlToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :espnId, :integer
    add_column :teams, :espnUrl, :string
    add_index :teams, :espnId, :unique => true
  end
end
