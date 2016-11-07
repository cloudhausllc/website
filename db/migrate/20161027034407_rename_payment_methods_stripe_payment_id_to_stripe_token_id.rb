class RenamePaymentMethodsStripePaymentIdToStripeTokenId < ActiveRecord::Migration
  def change
    rename_column :payment_methods, :stripe_payment_id, :stripe_token_id
  end
end
