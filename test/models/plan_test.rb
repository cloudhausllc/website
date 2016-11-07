require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  def setup
    StripeMock.start
    @unpublished_plan = {
        stripe_plan_id: 'unpublished_plan',
        stripe_plan_name: 'Unpublished Plan',
        stripe_plan_amount: 50000,
        stripe_plan_interval: 'month',
        stripe_plan_trial_period_days: 0
    }

    @stripe_unpublished_plan = Stripe::Plan.create(
        amount: @unpublished_plan[:stripe_plan_amount],
        interval: @unpublished_plan[:stripe_plan_interval],
        name: @unpublished_plan[:stripe_plan_name],
        currency: 'usd',
        id: @unpublished_plan[:stripe_plan_id],
        trial_period_days: @unpublished_plan[:stripe_plan_trial_period_days]
    )

  end

  def teardown
    StripeMock.stop
  end

  test 'should be valid' do
    plan_to_save = Plan.new(@unpublished_plan)
    assert plan_to_save.valid?
  end

  test 'plan id must be the same' do
    @unpublished_plan[:stripe_plan_id] = 'test'
        assert_not Plan.new(@unpublished_plan).valid?
  end

  test 'plan name must be the same' do
    @unpublished_plan[:stripe_plan_name] = 'Test Plan'
        assert_not Plan.new(@unpublished_plan).valid?
  end

  test 'plan amount must be the same' do
    @unpublished_plan[:stripe_plan_amount] = 10000
        assert_not Plan.new(@unpublished_plan).valid?
  end
  test 'plan interval must be the same' do
    @unpublished_plan[:stripe_plan_interval] = 'years'
        assert_not Plan.new(@unpublished_plan).valid?
  end
  test 'plan trial period days must be the same' do
    @unpublished_plan[:stripe_plan_trial_period_days] = 10
        assert_not Plan.new(@unpublished_plan).valid?
  end
end
