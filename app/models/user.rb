class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  has_secure_password

  # validates :password, presence: true, length: { minimum: 6 }

  validates :password, length: {minimum: 8}, allow_nil: true

  validate :create_stripe_customer, on: :create

  validate :set_stripe_plan, on: :update

  has_many :news_articles
  has_many :asset_tools, :class_name => 'Asset::Tool'
  has_many :index_images

  has_many :payment_methods

  belongs_to :plan

  cattr_accessor :current_user

  def current_subscription
    return self.user_subscriptions.current_subscription
  end

  def in_stripe?
    if self.stripe_customer_id.nil?
      return false
    else
      begin
        if Stripe::Customer.retrieve(self.stripe_customer_id)
          return true
        else
          return false
        end
      rescue => e
        raise e
        return false
      end
    end
  end

  def create_stripe_account
    begin
      self.update_attribute(:stripe_customer_id, Stripe::Customer.create(:email => self.email).id)
    rescue => e
      raise e
    end
  end


  private

  def self.cu_is_admin?
    return User.user_is_admin?(User.current_user)
  end


  def self.user_is_admin?(user)
    if user
      return user[:admin]
    else
      return false
    end
  end

  def create_stripe_customer
    begin
      create_stripe_account
    rescue => e
      error = 'There was a problem creating your account. Please contact info@cloudhaus.org for futher assistance.'
      error = Rails.env == 'development' ? "#{error} <br /> #{e.message}" : error
      errors.add(:base, error)
      #TODO: Eventually record e.message somewhere.
      # Some good information: http://stackoverflow.com/questions/15824860/where-and-how-to-handle-stripe-exceptions
      return false
    end
  end

  def set_stripe_plan
    if self.plan_id_changed?
      begin

        if self.plan_id.nil? or self.plan_id <= 0
          subscription = Stripe::Subscription.retrieve(self.stripe_subscription_id)
          subscription.delete
          self.plan_id = nil
          self.stripe_subscription_id = nil
        else
          if not self.stripe_subscription_id.nil?
            subscription = Stripe::Subscription.retrieve(self.stripe_subscription_id)
            subscription.plan = self.plan.stripe_plan_id
            self.stripe_subscription_id = subscription.save.id
          else
            #TODO: Problem here.

            self.stripe_subscription_id = Stripe::Subscription.create(
                :customer => self.stripe_customer_id,
                :plan => self.plan.stripe_plan_id
            ).id
          end
        end
      rescue => e
        error = 'There was a problem changing your plan. Please contact info@cloudhaus.org for futher assistance.'
        error = Rails.env == 'development' ? "#{error} <br /> #{e.message}" : error
        errors.add(:base, error)
        #TODO: Eventually record e.message somewhere.
        # Some good information: http://stackoverflow.com/questions/15824860/where-and-how-to-handle-stripe-exceptions
        return false
      end
    end
  end

end
