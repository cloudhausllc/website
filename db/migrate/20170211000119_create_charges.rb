class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.text :stripe_id
      t.text :customer_id
      t.text :source_id
      t.text :invoice_id

      t.integer :amount
      t.integer :amount_refunded
      t.integer :created
      t.text :description
      t.string :dispute
      t.string :failure_code
      t.string :failure_message
      t.json :outcome
      t.text :status

      t.index :customer_id
      t.index :stripe_id
      t.index :source_id
      t.index :invoice_id

      t.timestamps null: false
    end
  end
end
