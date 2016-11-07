class AddStripeCardIdToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :stripe_card_id, :text
  end
end
