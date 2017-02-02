require 'test_helper'

class PlanPolicyTest < PolicyAssertions::Test
  def setup
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @plan = plans(:published_plan)

    @available_actions = [:index, :create, :destroy]
  end

  def test_index
    #Only admins should be able to get index.
    assert_permit @admin_user, Plan
    refute_permit @regular_user, Plan
    refute_permit nil, Plan
  end

  def test_destroy
    #Admins should be able to destroy plans.
    assert_permit @admin_user, @plan

    #Regular users are not permitted to destroy plans.
    refute_permit @regular_user, @plan

    #Anon are not permitted to destroy plans.
    refute_permit nil, @plan
  end

  def test_create
    #Admins are allowed to create plans
    assert_permit @admin_user, Plan
    #Nobody else can create plans.
    refute_permit @regular_user, Plan
    refute_permit nil, Plan
  end

  def test_new
    refute_permit @admin_user, Plan
    refute_permit @regular_user, Plan
    refute_permit nil, Plan
  end

  def test_update
    assert_permit @admin_user, Plan
    refute_permit @regular_user, Plan
    refute_permit nil, Plan
  end

  def test_strong_parameters
    plan_attributes = @plan.attributes
    admin_params = [:stripe_plan_id, :active, :stripe_plan_name, :stripe_plan_amount,
                    :stripe_plan_interval, :stripe_plan_trial_period_days, :admin_selectable_only]
    regular_user_params = []
    anonymous_params = []

    assert_strong_parameters(@admin_user, Plan, plan_attributes, admin_params)

    assert_strong_parameters(@regular_user, Plan, plan_attributes, regular_user_params)

    assert_strong_parameters(nil, Plan, plan_attributes, anonymous_params)
  end

end