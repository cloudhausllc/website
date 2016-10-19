json.extract! membership_level, :id, :name, :monthly_payment, :created_at, :updated_at
json.url membership_level_url(membership_level, format: :json)