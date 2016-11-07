class AddSubscriptionFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plan_id, :integer
    add_column :users, :stripe_subscription_id, :text
  end
end
