require 'test_helper'
include SessionsHelper

class WebHook::StripeEventsControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
    @web_hook_stripe_event = web_hook_stripe_events(:one)
    @regular_user = users(:regular_user)
    @admin_user = users(:admin_user)
    @payment_method_regular_user = users(:payment_method_regular_user)

    [@payment_method_regular_user, @regular_user, @admin_user].each do |user|
      stripe_user = Stripe::Customer.create(email: user.email).to_hash
      user.update_attribute(:stripe_customer_id, stripe_user[:id])
    end

  end

  teardown do
    log_out
    StripeMock.stop
  end

  test 'admin should get index' do
    log_in(@admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:web_hook_stripe_events)
  end

  test 'regular user and anon should not get index' do
    get :index
    assert_redirected_to root_path

    log_in(@regular_user)
    get :index
    assert_redirected_to root_path
  end

  test 'admin should get show' do
    log_in(@admin_user)
    get :show, id: @web_hook_stripe_event
    assert_response :success
  end

  test 'regular user and anon should not get show' do
    get :show, id: @web_hook_stripe_event
    assert_redirected_to root_path

    log_in(@regular_user)
    get :show, id: @web_hook_stripe_event
    assert_redirected_to root_path
  end

  test 'should create customer.created event' do
    event = StripeMock.mock_webhook_event('customer.created', {
        id: @regular_user.stripe_customer_id,
        email: @regular_user.email,
    })

    assert_difference('WebHook::StripeEvent.count') do
      post :create, event.instance_values['original_values'], format: :json
      assert_response 200
    end
    @regular_user.reload
    assert_equal @regular_user.stripe_customer_id, event.data['object']['id']
  end

  test 'should create customer.deleted event' do
    event = StripeMock.mock_webhook_event('customer.deleted', {
        id: @regular_user.stripe_customer_id,
        email: @regular_user.email,
    })

    assert_difference('WebHook::StripeEvent.count') do
      post :create, event.instance_values['original_values'], format: :json
      assert_response 200
    end
    @regular_user.reload
    assert_nil @regular_user.stripe_customer_id
    assert_nil @regular_user.stripe_subscription_id
    assert_nil @regular_user.plan_id
    assert_empty @regular_user.payment_methods
  end

  test 'should create customer.updated event' do
    event = StripeMock.mock_webhook_event('customer.updated', {
        email: @payment_method_regular_user.email
    })

    original_payment_method = @payment_method_regular_user.payment_methods.first

    original_values = {
        last4: original_payment_method.last4,
        brand: original_payment_method.brand,
        exp_month: original_payment_method.exp_month,
        exp_year: original_payment_method.exp_year
    }

    assert_difference('WebHook::StripeEvent.count') do
      post :create, event.instance_values['original_values'], format: :json
      assert_response 200
    end
    new_payment_method = @payment_method_regular_user.payment_methods.first.reload
    card = event.instance_values['original_values'][:data][:object][:sources][:data][0]

    original_values.each do |original_payment_method|
      assert_not_equal new_payment_method[original_payment_method[0]], original_payment_method[1]
      assert_equal card[original_payment_method[0]], new_payment_method[original_payment_method[0]]
    end
  end
  #
  test 'should create customer.source.created event' do
    event = StripeMock.mock_webhook_event('customer.source.created', {
        email: @payment_method_regular_user.email,
        customer: @payment_method_regular_user.stripe_customer_id
    })

    original_payment_method = @payment_method_regular_user.payment_methods.first

    original_values = {
        last4: original_payment_method.last4,
        brand: original_payment_method.brand,
        exp_month: original_payment_method.exp_month,
        exp_year: original_payment_method.exp_year
    }

    assert_difference('WebHook::StripeEvent.count') do
      post :create, event.instance_values['original_values'], format: :json
      assert_response 200
    end

    new_payment_method = @payment_method_regular_user.payment_methods.first.reload
    new_payment_method_details = event.instance_values['original_values'][:data][:object]
    original_values.each do |original_payment_method|
      assert_not_equal new_payment_method[original_payment_method[0]], original_payment_method[1]
      assert_equal new_payment_method_details[original_payment_method[0]], new_payment_method[original_payment_method[0]]
    end
  end

  test 'should create customer.source.deleted event' do
    event = StripeMock.mock_webhook_event('customer.source.deleted', {
        email: @payment_method_regular_user.email,
    })

    assert_not_empty @payment_method_regular_user.payment_methods

    assert_difference('WebHook::StripeEvent.count') do
      assert_difference('PaymentMethod.count', -1) do
        post :create, event.instance_values['original_values'], format: :json
        assert_response 200
      end
    end
    @payment_method_regular_user.payment_methods.reload
    assert_empty @payment_method_regular_user.payment_methods
  end

  test 'should create customer.subscription.created event' do
    event = StripeMock.mock_webhook_event('customer.subscription.created', {
        customer: @payment_method_regular_user.stripe_customer_id,
        email: @payment_method_regular_user.email,
    })

    original_plan_id = @payment_method_regular_user.plan_id

    assert_difference('WebHook::StripeEvent.count') do
      post :create, event.instance_values['original_values'], format: :json
      assert_response 200
    end

    new_plan_id = Plan.find_by_stripe_plan_id(event.instance_values['original_values'][:data][:object][:plan][:id]).id
    current_customer_plan_id = @payment_method_regular_user.reload.plan_id
    assert_not_equal new_plan_id, original_plan_id
    assert_not_equal current_customer_plan_id, original_plan_id
    assert_equal current_customer_plan_id, new_plan_id
  end

  test 'should create customer.subscription.deleted event' do
    assert_not_nil @payment_method_regular_user.plan_id

    event = StripeMock.mock_webhook_event('customer.subscription.deleted', {
        customer: @payment_method_regular_user.stripe_customer_id,
        email: @payment_method_regular_user.email,
    })

    assert_difference('WebHook::StripeEvent.count') do
      post :create, event.instance_values['original_values'], format: :json
      assert_response 200
    end

    assert_nil @payment_method_regular_user.reload.plan_id
  end

  test 'should create customer.subscription.updated event' do
    event = StripeMock.mock_webhook_event('customer.subscription.updated', {
        customer: @payment_method_regular_user.stripe_customer_id,
        email: @payment_method_regular_user.email,
    })

    original_plan_id = @payment_method_regular_user.plan_id


    assert_difference('WebHook::StripeEvent.count') do
      post :create, event.instance_values['original_values'], format: :json
      assert_response 200
    end

    new_plan_id = Plan.find_by_stripe_plan_id(event.instance_values['original_values'][:data][:object][:plan][:id]).id
    current_customer_plan_id = @payment_method_regular_user.reload.plan_id
    assert_not_equal new_plan_id, original_plan_id
    assert_not_equal current_customer_plan_id, original_plan_id
    assert_equal current_customer_plan_id, new_plan_id
  end

  test 'should create plan.deleted event' do
    event = StripeMock.mock_webhook_event('plan.deleted')
    event_id = event.instance_values['original_values'][:data][:object][:id]
    assert_equal Plan.find_by_stripe_plan_id(event_id).active, true

    assert_difference('WebHook::StripeEvent.count') do
      post :create, event.instance_values['original_values'], format: :json
      assert_response 200
    end

    assert_equal Plan.find_by_stripe_plan_id(event_id).reload.active, false
  end

  test 'should create plan.updated event' do
    event = StripeMock.mock_webhook_event('plan.updated')
    event_id = event.instance_values['original_values'][:data][:object][:id]

    plan = Plan.find_by_stripe_plan_id(event_id)
    old_values = {
        stripe_plan_amount: plan.stripe_plan_amount,
        stripe_plan_interval: plan.stripe_plan_interval,
        stripe_plan_trial_period_days: plan.stripe_plan_trial_period_days,
        stripe_plan_name: plan.stripe_plan_name
    }

    assert_difference('WebHook::StripeEvent.count') do
      post :create, event.instance_values['original_values'], format: :json
      assert_response 200
    end

    plan = plan.reload
    old_values.each do |old_value|
      assert_not_equal plan[old_value[0]], old_value[1]
    end

    assert_equal plan[:stripe_plan_amount], event.instance_values['original_values'][:data][:object][:amount]
    assert_equal plan[:stripe_plan_interval], event.instance_values['original_values'][:data][:object][:interval]
    assert_equal plan[:stripe_plan_trial_period_days], event.instance_values['original_values'][:data][:object][:trial_period_days]
    assert_equal plan[:stripe_plan_name], event.instance_values['original_values'][:data][:object][:name]
  end

  test 'invalid web hooks should return 500' do
    assert_difference('WebHook::StripeEvent.count', 0) do
      post :create, {invalid: :hook}, format: :json
      assert_response 500
    end
  end

  private

  def ensure_marked_as_processing(event)

  end

  def ensure_marked_as_processed(event)

  end
end
