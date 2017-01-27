class CreateWebHookStripeEvents < ActiveRecord::Migration
  def change
    create_table :web_hook_stripe_events do |t|
      t.boolean :livemode
      t.text :stripe_id
      t.text :object
      t.text :request
      t.datetime :api_version
      t.json :data

      t.timestamps null: false
    end
  end
end
