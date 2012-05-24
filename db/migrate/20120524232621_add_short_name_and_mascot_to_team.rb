class AddShortNameAndMascotToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :short_name, :string
    add_column :teams, :mascot, :string
  end
end
