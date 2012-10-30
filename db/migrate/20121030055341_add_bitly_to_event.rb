class AddBitlyToEvent < ActiveRecord::Migration
  def change
    add_column :events, :bitly, :string
  end
end
