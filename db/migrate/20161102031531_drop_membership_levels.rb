class DropMembershipLevels < ActiveRecord::Migration
  def change
    drop_table :membership_levels do

    end
  end
end
