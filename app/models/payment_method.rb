class PaymentMethod < ActiveRecord::Base
  before_validation :set_user

  validate :user_id_must_be_cu_if_not_admin
  validate :stripe_tie_payment_method_to_user, on: :create
  validates_presence_of :brand, :exp_month, :exp_year, :last4, :stripe_token_id, :stripe_card_id
  validates_numericality_of :exp_month, :exp_year, :last4
  validates :exp_month, :numericality => {:greater_than => 0, :less_than_or_equal_to => 12}
  validates :last4, length: {is: 4}
  validates_format_of :last4, with: /\d{4}/


  after_create :deactivate_old_methods
  before_destroy :remove_from_stripe
  before_destroy :remove_user_subscription

  belongs_to :user
  has_many :plans


  private

  def user_id_must_be_cu_if_not_admin
    if User.current_user.nil?
      errors.add(:base, 'You do not have permission to perform this action.')
      return false
    elsif self.user_id != User.current_user.id and not User.current_user.admin
      errors.add(:base, 'You do not have permission to perform this action.')
      return false
    end
  end

  def deactivate_old_methods
    PaymentMethod.where(user_id: self.user_id).where('id != ?', self.id).delete_all
  end

  def set_user
    if self.user_id.nil?
      self.user_id = User.current_user.id
    end
  end

  def stripe_tie_payment_method_to_user
    begin
      customer = Stripe::Customer.retrieve(self.user.stripe_customer_id)
      customer.source = self.stripe_token_id
      response = customer.save
      self.stripe_card_id = response.sources.data[0].id
      return true
    rescue => e
      error = 'There was a problem creating your new payment source.'
      error = Rails.env == 'development' ? "#{error} <br /> #{e.message}" : error
      errors.add(:base, error)
      #TODO: Eventually record e.message somewhere.
      # Some good information: http://stackoverflow.com/questions/15824860/where-and-how-to-handle-stripe-exceptions
      return false
    end
  end

  def remove_from_stripe
    begin
      Stripe::Customer.retrieve(self.user.stripe_customer_id).sources.retrieve(self.stripe_card_id).delete()
    rescue => e
      error = 'There was a problem removing this payment source. Please contact info@cloudhaus.org for further assistance.'
      error = Rails.env == 'development' ? "#{error} <br /> #{e.message}" : error
      errors.add(:base, error)
      #TODO: Eventually record e.message somewhere.
      # Some good information: http://stackoverflow.com/questions/15824860/where-and-how-to-handle-stripe-exceptions
      return false
    end
  end

  def remove_user_subscription
    begin
      if not self.user.stripe_subscription_id.nil?

        #Remove the card from the user in Stripe.
        Stripe::Customer.retrieve(self.user.stripe_customer_id).sources.retrieve(self.stripe_card_id).delete()

        #Remove the users subscription from Stripe.
        Stripe::Subscription.retrieve(self.user.stripe_subscription_id)

        #Update our database to reflect the changes.
        self.user.update_attributes(plan_id: nil, stripe_subscription_id: nil)
      end

    rescue => e
      error = 'There was a problem removing your subscription. Please contact info@cloudhaus.org for further assistance.'
      error = Rails.env == 'development' ? "#{error} <br /> #{self.user.errors.inspect}" : error
      errors.add(:base, error)
      return false
    end
  end

end
