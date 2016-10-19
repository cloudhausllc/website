class CreateMembershipLevels < ActiveRecord::Migration
  def change
    create_table :membership_levels do |t|
      t.decimal :monthly_payment

      t.timestamps null: false
    end
  end
end
