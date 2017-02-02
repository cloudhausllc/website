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
    must_be_admin(user, record)
  end

  def new?
    false
  end

  def permitted_attributes
    if not user.nil? and user[:admin]
      [:stripe_plan_id, :active, :stripe_plan_name, :stripe_plan_amount,
       :stripe_plan_interval, :stripe_plan_trial_period_days, :admin_selectable_only]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user_is_admin(user, scope)
        scope.where(active: true)
      else
        scope.where(admin_selectable_only: false)
      end
    end
  end


end

