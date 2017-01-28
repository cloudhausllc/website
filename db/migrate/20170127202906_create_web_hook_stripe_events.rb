class CreateWebHookStripeEvents < ActiveRecord::Migration
  def change
    create_table :web_hook_stripe_events do |t|
      t.boolean :livemode, null: false
      t.text :event_type, null: false
      t.text :stripe_id, null: false
      t.text :object, null: false
      t.text :request
      t.datetime :api_version
      t.json :data, null: false
      t.timestamps null: false
    end
    add_index :web_hook_stripe_events, :stripe_id, unique: true
  end
end
