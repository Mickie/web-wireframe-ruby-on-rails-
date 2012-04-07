class MakeDivisionBelongToLeague < ActiveRecord::Migration
  def up
    change_table :divisions do |t|
      t.remove :conference_id
      t.references :league, null:false, default:1
    end 
  end

  def down
    change_table :divisions do |t|
      t.remove :league_id
      t.references :conference, null:false, default:1
    end
  end
end
