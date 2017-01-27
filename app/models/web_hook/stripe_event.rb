class WebHook::StripeEvent < ActiveRecord::Base
  validates :event_type, :stripe_id, :object, :api_version, :data, presence: true
  validates_inclusion_of :livemode, in: [true, false]
  validates_uniqueness_of :stripe_id, case_sensitive: :true
end
