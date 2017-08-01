class ChangeDefaultActiveForUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :active, false
  end
end