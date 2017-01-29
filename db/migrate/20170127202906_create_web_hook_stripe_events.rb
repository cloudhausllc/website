class CreateWebHookStripeEvents < ActiveRecord::Migration
  def change
    create_table :web_hook_stripe_events do |t|
      t.boolean :livemode
      t.text :event_type
      t.text :stripe_id
      t.text :object
      t.text :request
      t.datetime :api_version
      t.json :data
      t.timestamps null: false
    end
    add_index :web_hook_stripe_events, :stripe_id, unique: true
  end
end
