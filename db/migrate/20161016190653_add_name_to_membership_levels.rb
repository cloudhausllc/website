class AddNameToMembershipLevels < ActiveRecord::Migration
  def change
    add_column :membership_levels, :name, :text
  end
end
