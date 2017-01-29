class Payment < ActiveRecord::Base
  include SessionsHelper

  before_validation :convert_to_decimal
  validates :amount, :numericality => {:greater_than_or_equal_to => 500}

  before_create :set_user_if_new
  before_create :send_to_stripe

  belongs_to :user

  def set_user_if_new
    if logged_in?
      if (not User.cu_is_admin?) or (User.cu_is_admin? and self.user_id.nil?)
        self.user_id = current_user.id
      end
    end
  end

  def send_to_stripe
    result = Stripe::Charge.create(
        :amount => amount,
        :currency => 'usd',
        :source => stripe_token,
        :description => 'Cloudhaus Charge' #TODO: Probably make this a field eventually...
    )

    self.status = result[:status]
    self.outcome = result[:outcome].to_json
  rescue Stripe::CardError => e
    errors.add(:base, e.message)
  end

  def convert_to_decimal
    self.amount = self.amount*100
  end

  def pretty_type
    self.class.to_s.split('::').last.titleize
  end

end
