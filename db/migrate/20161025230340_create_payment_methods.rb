class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.integer :user_id
      t.text :brand
      t.integer :exp_month
      t.integer :exp_year
      t.text :last4
      t.text :stripe_payment_id

      t.timestamps null: false
    end
  end
end
