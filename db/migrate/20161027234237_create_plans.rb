class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.text :stripe_plan_id
      t.boolean :active, null: false, default: true

      t.text :stripe_plan_name
      t.integer :stripe_plan_amount
      t.text :stripe_plan_interval
      t.text :stripe_plan_id
      t.integer :stripe_plan_trial_period_days


      t.timestamps null: false
    end
  end
end
