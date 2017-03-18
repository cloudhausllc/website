class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.text :stripe_id
      t.text :subscription_id
      t.text :charge_id
      t.text :customer_id

      t.integer :amount_due
      t.integer :attempt_count
      t.boolean :attempted
      t.boolean :closed
      t.integer :date
      t.text :description
      t.boolean :livemode
      t.integer :next_payment_attempt
      t.integer :period_start
      t.integer :period_end
      t.integer :subtotal
      t.integer :tax
      t.integer :tax_percent
      t.integer :total
      t.boolean :payment_succeeded
      t.timestamps null: false

      t.index :stripe_id
      t.index :subscription_id
      t.index :charge_id
      t.index :customer_id
    end
  end
end
