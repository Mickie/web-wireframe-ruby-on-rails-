class AddDescriptionAndBitlyToTailgate < ActiveRecord::Migration
  def change
    add_column :tailgates, :description, :string
    add_column :tailgates, :bitly, :string
  end
end
