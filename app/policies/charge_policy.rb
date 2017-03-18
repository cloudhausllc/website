class ChargePolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    (must_be_logged_in(user, record) and record.customer_id == user.stripe_customer_id) or must_be_admin(user, record)
  end

  def edit?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def create?
    false
  end

  def permitted_attributes
    []
  end

end
