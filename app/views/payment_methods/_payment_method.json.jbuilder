json.extract! payment_method, :id, :user_id, :brand, :exp_month, :exp_year, :last4, :active, :created_at, :updated_at
json.url payment_method_url(payment_method, format: :json)