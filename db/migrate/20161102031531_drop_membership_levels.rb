class DropMembershipLevels < ActiveRecord::Migration
  def change
    drop_table :membership_levels
  end
end
