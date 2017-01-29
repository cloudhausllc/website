class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.integer :user_id
      t.text :type
      t.text :stripe_token
      t.text :notes
      t.text :status
      t.json :outcome
      t.timestamps null: false
    end
  end
end
