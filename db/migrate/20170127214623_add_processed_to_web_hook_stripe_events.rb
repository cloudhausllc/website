class AddProcessedToWebHookStripeEvents < ActiveRecord::Migration
  def change
    add_column :web_hook_stripe_events, :processing, :timestamp
    add_column :web_hook_stripe_events, :processed, :timestamp
  end
end
