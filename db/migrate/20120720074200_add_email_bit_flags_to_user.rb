class AddEmailBitFlagsToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_bit_flags, :integer, default:0, null:false
  end
end
