class AddLargeImageBitlyToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :large_logo_bitly, :string
  end
end
