require 'test_helper'
include SessionsHelper

class ChargesControllerTest < ActionController::TestCase
  setup do
    @test_charge = charges(:admin_charge)
    @admin_charge = charges(:admin_charge)
    @regular_user_charge = charges(:regular_user_charge)

    @admin_user = users(:admin_charge_user)
    # @admin_charge.update(customer_id: @admin_user.stripe_customer_id)
    # @admin_charge.save(validate: false)

    @regular_user = users(:regular_charge_user)

    StripeMock.start
  end

  teardown do
    log_out
    StripeMock.stop
  end

  test 'nobody should be able to get index' do
    assert_raises(AbstractController::ActionNotFound) do
      get :index
      assert_response :missing
      assert_nil assigns(:charges)
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      get :index
      assert_response :missing
      assert_nil assigns(:charges)
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      get :index
      assert_response :missing
      assert_nil assigns(:charges)
    end
  end

  test 'nobody should be able to get new' do
    assert_raises(AbstractController::ActionNotFound) do
      get :new
      assert_response :missing
      assert_nil assigns(:charges)
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      get :new
      assert_response :missing
      assert_nil assigns(:charges)
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      get :new
      assert_response :missing
      assert_nil assigns(:charges)
    end
  end

  test 'should create charge' do
    assert_raises(AbstractController::ActionNotFound) do
      assert_difference('Charge.count', 0) do
        post :create, charge: {amount: @test_charge.amount, amount_refunded: @test_charge.amount_refunded, created: @test_charge.created, customer_id: @test_charge.customer_id, description: @test_charge.description, dispute: @test_charge.dispute, failure_code: @test_charge.failure_code, failure_message: @test_charge.failure_message, outcome: @test_charge.outcome, source_id: @test_charge.source_id, status: @test_charge.status, stripe_id: @test_charge.stripe_id}
      end
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      assert_difference('Charge.count', 0) do
        post :create, charge: {amount: @test_charge.amount, amount_refunded: @test_charge.amount_refunded, created: @test_charge.created, customer_id: @test_charge.customer_id, description: @test_charge.description, dispute: @test_charge.dispute, failure_code: @test_charge.failure_code, failure_message: @test_charge.failure_message, outcome: @test_charge.outcome, source_id: @test_charge.source_id, status: @test_charge.status, stripe_id: @test_charge.stripe_id}
      end
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      assert_difference('Charge.count', 0) do
        post :create, charge: {amount: @test_charge.amount, amount_refunded: @test_charge.amount_refunded, created: @test_charge.created, customer_id: @test_charge.customer_id, description: @test_charge.description, dispute: @test_charge.dispute, failure_code: @test_charge.failure_code, failure_message: @test_charge.failure_message, outcome: @test_charge.outcome, source_id: @test_charge.source_id, status: @test_charge.status, stripe_id: @test_charge.stripe_id}
      end
      assert_response :missing
    end
  end

  test 'regular user can show own charge' do
    log_in(@regular_user)
    @regular_user_charge.update!(customer_id: @regular_user.stripe_customer_id)

    get :show, id: @regular_user_charge
    assert_response :success
    assert_not_nil assigns(:charge)
  end

  test 'regular user can not show other charge' do
    log_in(@regular_user)
    get :show, id: @admin_charge
    assert_redirected_to root_path
  end

  test 'admin can show own charge' do
    log_in(@admin_user)
    @admin_charge.update!(customer_id: @admin_user.stripe_customer_id)
    get :show, id: @admin_charge
    assert_response :success
    assert_not_nil assigns(:charge)
  end

  test 'admin can show other charge' do
    log_in(@admin_user)
    get :show, id: @regular_user_charge
    assert_response :success
    assert_not_nil assigns(:charge)
  end

  test 'anon can not show any charges' do
    get :show, id: @regular_user_charge
    assert_redirected_to root_path

    get :show, id: @admin_charge
    assert_redirected_to root_path

  end

  test 'nobody should not get edit' do
    assert_raises(AbstractController::ActionNotFound) do
      get :edit, id: @test_charge
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      get :edit, id: @regular_user_charge
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      get :edit, id: @admin_charge
      assert_response :missing
    end
  end

  test 'nobody should update charge' do
    original_charge_amount = @test_charge.amount

    assert_raises(AbstractController::ActionNotFound) do
      patch :update, id: @test_charge, charge: {amount: @test_charge.amount+1000, amount_refunded: @test_charge.amount_refunded, created: @test_charge.created, customer_id: @test_charge.customer_id, description: @test_charge.description, dispute: @test_charge.dispute, failure_code: @test_charge.failure_code, failure_message: @test_charge.failure_message, outcome: @test_charge.outcome, source_id: @test_charge.source_id, status: @test_charge.status, stripe_id: @test_charge.stripe_id}
      assert_response :missing
      @test_charge.reload
      assert_equal original_charge_amount, @test_charge.amount
    end

    original_charge_amount = @regular_user_charge.amount

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      patch :update, id: @regular_user_charge, charge: {amount: @regular_user_charge.amount+1000, amount_refunded: @regular_user_charge.amount_refunded, created: @regular_user_charge.created, customer_id: @regular_user_charge.customer_id, description: @regular_user_charge.description, dispute: @regular_user_charge.dispute, failure_code: @regular_user_charge.failure_code, failure_message: @regular_user_charge.failure_message, outcome: @regular_user_charge.outcome, source_id: @regular_user_charge.source_id, status: @regular_user_charge.status, stripe_id: @regular_user_charge.stripe_id}
      assert_response :missing
      @regular_user_charge.reload
      assert_equal original_charge_amount, @regular_user_charge.amount
    end

    original_charge_amount = @admin_charge.amount

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      patch :update, id: @admin_charge, charge: {amount: @admin_charge.amount+1000, amount_refunded: @admin_charge.amount_refunded, created: @admin_charge.created, customer_id: @admin_charge.customer_id, description: @admin_charge.description, dispute: @admin_charge.dispute, failure_code: @admin_charge.failure_code, failure_message: @admin_charge.failure_message, outcome: @admin_charge.outcome, source_id: @admin_charge.source_id, status: @admin_charge.status, stripe_id: @admin_charge.stripe_id}
      assert_response :missing
      @admin_charge.reload
      assert_equal original_charge_amount, @admin_charge.amount
    end
  end

  test 'nobody should destroy charge' do
    assert_raises(AbstractController::ActionNotFound) do
      assert_difference('Charge.count', 0) do
        delete :destroy, id: @test_charge
      end
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      assert_difference('Charge.count', 0) do
        delete :destroy, id: @regular_user_charge
      end
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      assert_difference('Charge.count', 0) do
        delete :destroy, id: @admin_charge
      end
      assert_response :missing
    end
  end
end
