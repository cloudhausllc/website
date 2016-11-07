class PlanPolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    must_be_logged_in(user, record) and user[:admin]
  end

  def destroy?
    must_be_logged_in(user, record) and user[:admin]
  end

  def create?
    must_be_logged_in(user, record) and user[:admin]
  end

  def update?
    false
  end

  def new?
    false
  end

  def permitted_attributes
    if not user.nil? and user[:admin]
      [:stripe_plan_id, :active, :stripe_plan_name, :stripe_plan_amount,
       :stripe_plan_interval, :stripe_plan_trial_period_days]
    else
      []
    end
  end
end

