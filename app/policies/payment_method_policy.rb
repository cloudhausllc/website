class PaymentMethodPolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def destroy?
    must_be_logged_in(user, record) and (user[:admin] or record.user_id == user.id)
  end

  def create?
    #Users can only have one payment method.
    must_be_logged_in(user, record) and user.payment_methods.count == 0
  end

  def update?
    false
  end

  def new?
    false
  end

  def permitted_attributes
    if not user.nil?
      [:user_id, :user_id, :brand, :exp_month, :exp_year, :last4, :stripe_token_id, :stripe_card_id]
    else
      []
    end
  end
end

