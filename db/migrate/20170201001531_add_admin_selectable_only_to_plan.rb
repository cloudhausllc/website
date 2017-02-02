class AddAdminSelectableOnlyToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :admin_selectable_only, :boolean, null: false, default: true
  end
end
