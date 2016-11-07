class Plan < ActiveRecord::Base
  has_many :users

  validate :verify_values, on: :create

  private

  def verify_values
    begin
      errors_found = false
      stripe_plan = Stripe::Plan.retrieve(self.stripe_plan_id).to_h

      [{local: :stripe_plan_name, remote: :name},
       {local: :stripe_plan_amount, remote: :amount},
       {local: :stripe_plan_interval, remote: :interval}
      ].each do |set|
        if self[set[:local]] != stripe_plan[set[:remote]]
          errors.add(:base, "There was an error activating this plan: #{set[:remote].to_s.humanize} mismatch.")
          errors_found = true
        end
      end

      if self.stripe_plan_trial_period_days != stripe_plan[:trial_period_days].to_i
        errors.add(:base, 'There was an error activating this plan: Trial period days mismatch.')
        errors_found = true
      end
      return !errors_found
    rescue => e
      error = 'There was a problem saving this plan.'
      error = Rails.env == 'development' ? "#{error} <br /> #{e.message}" : error
      errors.add(:base, error)
      return false
    end
  end

end
