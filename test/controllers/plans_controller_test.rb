require 'test_helper'
include SessionsHelper

class PlansControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @published_plan = plans(:published_plan)
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
        plan_trial_period_days: @unpublished_plan[:stripe_plan_trial_period_days]
    )

    @stripe_published_plan = Stripe::Plan.create(
            amount: @published_plan[:stripe_plan_amount],
            interval: @published_plan[:stripe_plan_interval],
            name: @published_plan[:stripe_plan_name],
            currency: 'usd',
            id: @published_plan[:stripe_plan_id]
        )
  end

  teardown do
    log_out
    StripeMock.stop
  end

  test 'admin should get list of plans' do
    log_in(@admin_user)
    get :index
    assert_includes(assigns(:plans), @published_plan)
    assert_response :success
    assert_not_nil assigns(:plans)
  end

  test 'regular user should not list plans' do
    log_in(@regular_user)
    get :index
    assert_nil assigns(:plans)
    assert_redirected_to root_path
  end

  test 'anonymous user should not list plans' do
    assert_equal false, logged_in?
    get :index
    assert_nil assigns(:plans)
    assert_redirected_to root_path
  end

  test 'should create plan' do
    log_in(@admin_user)
    assert_difference('Plan.count', 1) do
      post :create, plan: @unpublished_plan
    end

    assert_redirected_to plans_path
  end

  test 'regular user should not create plan' do
    log_in(@regular_user)
    assert_difference('Plan.count', 0) do
      post :create, plan: @unpublished_plan
    end

    assert_redirected_to root_path
  end

  test 'anonymous user should not create plan' do
    assert_equal logged_in?, false
    assert_difference('Plan.count', 0) do
      post :create, plan: @unpublished_plan
    end

    assert_redirected_to root_path
  end

  test 'admin should be able to destroy plan' do
    log_in(@admin_user)

    assert_difference('Plan.count', 0) do
      delete :destroy, id: @published_plan
    end

    assert_equal false, @published_plan.reload.active

    assert_redirected_to plans_path
  end

  test 'regular users should not be able to destroy plan' do
    log_in(@regular_user)
    assert_difference('Plan.count', 0) do
      delete :destroy, id: @published_plan
    end

    assert_equal true, @published_plan.reload.active

    assert_redirected_to root_path
  end

  test 'anonymous users should not be able to destroy plan' do
    assert_equal false, logged_in?
    assert_difference('Plan.count', 0) do
      delete :destroy, id: @published_plan
    end

    assert_equal true, @published_plan.reload.active

    assert_redirected_to root_path
  end

end
