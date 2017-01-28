class WebHook::StripeEvent < ActiveRecord::Base
  validates :event_type, :stripe_id, :object, :data, presence: true
  validates_inclusion_of :livemode, in: [true, false]
  validates_uniqueness_of :stripe_id, case_sensitive: :true

  def mark_as_processing
    self.processing = Time.now
    self.save
  end

  def mark_as_processed
    self.processed = Time.now
    self.save
  end

  def self.mark_as_processing(id)
    WebHook::StripeEvent.find(id).mark_as_processing
  end

  def self.mark_as_processed(id)
    WebHook::StripeEvent.find(id).mark_as_processed
  end
end
