json.extract! plan, :id, :stripe_plan_id, :available, :created_at, :updated_at
json.url plan_url(plan, format: :json)