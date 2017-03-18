# require 'test_helper'
#
# class InvoicesControllerTest < ActionController::TestCase
#   setup do
#     @invoice = invoices(:one)
#   end
#
#   test "should get index" do
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:invoices)
#   end
#
#   test "should get new" do
#     get :new
#     assert_response :success
#   end
#
#   test "should create invoice" do
#     assert_difference('Invoice.count') do
#       post :create, invoice: { amount_due: @invoice.amount_due, attempt_count: @invoice.attempt_count, attempted: @invoice.attempted, charge_id: @invoice.charge_id, closed: @invoice.closed, customer: @invoice.customer, date: @invoice.date, description: @invoice.description, livemode: @invoice.livemode, next_payment_attempt: @invoice.next_payment_attempt, payment_succeeded: @invoice.payment_succeeded, period_end: @invoice.period_end, period_start: @invoice.period_start, stripe_id: @invoice.stripe_id, subscription_id: @invoice.subscription_id, subtotal: @invoice.subtotal, tax: @invoice.tax, tax_percent: @invoice.tax_percent, total: @invoice.total }
#     end
#
#     assert_redirected_to invoice_path(assigns(:invoice))
#   end
#
#   test "should show invoice" do
#     get :show, id: @invoice
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get :edit, id: @invoice
#     assert_response :success
#   end
#
#   test "should update invoice" do
#     patch :update, id: @invoice, invoice: { amount_due: @invoice.amount_due, attempt_count: @invoice.attempt_count, attempted: @invoice.attempted, charge_id: @invoice.charge_id, closed: @invoice.closed, customer: @invoice.customer, date: @invoice.date, description: @invoice.description, livemode: @invoice.livemode, next_payment_attempt: @invoice.next_payment_attempt, payment_succeeded: @invoice.payment_succeeded, period_end: @invoice.period_end, period_start: @invoice.period_start, stripe_id: @invoice.stripe_id, subscription_id: @invoice.subscription_id, subtotal: @invoice.subtotal, tax: @invoice.tax, tax_percent: @invoice.tax_percent, total: @invoice.total }
#     assert_redirected_to invoice_path(assigns(:invoice))
#   end
#
#   test "should destroy invoice" do
#     assert_difference('Invoice.count', -1) do
#       delete :destroy, id: @invoice
#     end
#
#     assert_redirected_to invoices_path
#   end
# end


require 'test_helper'
include SessionsHelper

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @charge = invoices(:admin_invoice)
    @admin_invoice = invoices(:admin_invoice)
    @regular_user_invoice = invoices(:regular_user_invoice)

    @admin_user = users(:admin_invoice_user)

    @regular_user = users(:regular_invoice_user)

    @invoice = invoices(:regular_user_invoice);

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
      assert_nil assigns(:invoices)
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      get :index
      assert_response :missing
      assert_nil assigns(:invoices)
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      get :index
      assert_response :missing
      assert_nil assigns(:invoices)
    end
  end

  test 'nobody should be able to get new' do
    assert_raises(AbstractController::ActionNotFound) do
      get :new
      assert_response :missing
      assert_nil assigns(:invoices)
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      get :new
      assert_response :missing
      assert_nil assigns(:invoices)
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      get :new
      assert_response :missing
      assert_nil assigns(:invoices)
    end
  end

  test 'should create charge' do
    assert_raises(AbstractController::ActionNotFound) do
      assert_difference('Invoice.count', 0) do
        post :create, invoice: {amount_due: @invoice.amount_due, attempt_count: @invoice.attempt_count, attempted: @invoice.attempted, charge_id: @invoice.charge_id, closed: @invoice.closed, customer_id: @invoice.customer_id, date: @invoice.date, description: @invoice.description, livemode: @invoice.livemode, next_payment_attempt: @invoice.next_payment_attempt, payment_succeeded: @invoice.payment_succeeded, period_end: @invoice.period_end, period_start: @invoice.period_start, stripe_id: @invoice.stripe_id, subscription_id: @invoice.subscription_id, subtotal: @invoice.subtotal, tax: @invoice.tax, tax_percent: @invoice.tax_percent, total: @invoice.total}
      end
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      assert_difference('Invoice.count', 0) do
        post :create, invoice: {amount_due: @invoice.amount_due, attempt_count: @invoice.attempt_count, attempted: @invoice.attempted, charge_id: @invoice.charge_id, closed: @invoice.closed, customer_id: @invoice.customer_id, date: @invoice.date, description: @invoice.description, livemode: @invoice.livemode, next_payment_attempt: @invoice.next_payment_attempt, payment_succeeded: @invoice.payment_succeeded, period_end: @invoice.period_end, period_start: @invoice.period_start, stripe_id: @invoice.stripe_id, subscription_id: @invoice.subscription_id, subtotal: @invoice.subtotal, tax: @invoice.tax, tax_percent: @invoice.tax_percent, total: @invoice.total}
      end
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      assert_difference('Invoice.count', 0) do
        post :create, invoice: {amount_due: @invoice.amount_due, attempt_count: @invoice.attempt_count, attempted: @invoice.attempted, charge_id: @invoice.charge_id, closed: @invoice.closed, customer_id: @invoice.customer_id, date: @invoice.date, description: @invoice.description, livemode: @invoice.livemode, next_payment_attempt: @invoice.next_payment_attempt, payment_succeeded: @invoice.payment_succeeded, period_end: @invoice.period_end, period_start: @invoice.period_start, stripe_id: @invoice.stripe_id, subscription_id: @invoice.subscription_id, subtotal: @invoice.subtotal, tax: @invoice.tax, tax_percent: @invoice.tax_percent, total: @invoice.total}
      end
      assert_response :missing
    end
  end

  test 'regular user can show own invoice' do
    log_in(@regular_user)
    @regular_user_invoice.update!(customer_id: @regular_user.stripe_customer_id)

    get :show, id: @regular_user_invoice
    assert_response :success
    assert_not_nil assigns(:invoice)
  end

  test 'regular user can not show other invoice' do
    log_in(@regular_user)
    get :show, id: @admin_invoice
    assert_redirected_to root_path
  end

  test 'admin can show own invoice' do
    log_in(@admin_user)
    @admin_invoice.update!(customer_id: @admin_user.stripe_customer_id)
    get :show, id: @admin_invoice
    assert_response :success
    assert_not_nil assigns(:invoice)

  end

  test 'admin can show other invoice' do
    log_in(@admin_user)
    get :show, id: @regular_user_invoice
    assert_response :success
    assert_not_nil assigns(:invoice)
  end

  test 'anon can not show any invoices' do
    get :show, id: @regular_user_invoice
    assert_redirected_to root_path

    get :show, id: @admin_invoice
    assert_redirected_to root_path

  end

  test 'nobody should not get edit' do
    assert_raises(AbstractController::ActionNotFound) do
      get :edit, id: @invoice
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      get :edit, id: @regular_user_invoice
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      get :edit, id: @admin_invoice
      assert_response :missing
    end
  end

  test 'nobody should update invoice' do

    original_invoice_amount = @invoice.amount_due

    assert_raises(AbstractController::ActionNotFound) do
      patch :update, id: @invoice, invoice: {amount_due: @invoice.amount_due, attempt_count: @invoice.attempt_count, attempted: @invoice.attempted, charge_id: @invoice.charge_id, closed: @invoice.closed, customer_id: @regular_user_invoice.customer_id, date: @invoice.date, description: @invoice.description, livemode: @invoice.livemode, next_payment_attempt: @invoice.next_payment_attempt, payment_succeeded: @invoice.payment_succeeded, period_end: @invoice.period_end, period_start: @invoice.period_start, stripe_id: @invoice.stripe_id, subscription_id: @invoice.subscription_id, subtotal: @invoice.subtotal, tax: @invoice.tax, tax_percent: @invoice.tax_percent, total: @invoice.total}
      assert_response :missing
      @invoice.reload
      assert_equal original_invoice_amount, @invoice.amount_due
    end

    original_invoice_amount = @regular_user_invoice.amount_due

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      patch :update, id: @regular_user_invoice, invoice: {amount_due: @regular_user_invoice.amount_due, attempt_count: @regular_user_invoice.attempt_count, attempted: @regular_user_invoice.attempted, charge_id: @regular_user_invoice.charge_id, closed: @regular_user_invoice.closed, customer_id: @regular_user_invoice.customer_id, date: @regular_user_invoice.date, description: @regular_user_invoice.description, livemode: @regular_user_invoice.livemode, next_payment_attempt: @regular_user_invoice.next_payment_attempt, payment_succeeded: @regular_user_invoice.payment_succeeded, period_end: @regular_user_invoice.period_end, period_start: @regular_user_invoice.period_start, stripe_id: @regular_user_invoice.stripe_id, subscription_id: @regular_user_invoice.subscription_id, subtotal: @regular_user_invoice.subtotal, tax: @regular_user_invoice.tax, tax_percent: @regular_user_invoice.tax_percent, total: @regular_user_invoice.total}
      assert_response :missing
      @regular_user_invoice.reload
      assert_equal original_invoice_amount, @regular_user_invoice.amount
    end

    original_invoice_amount = @admin_invoice.amount_due

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      patch :update, id: @admin_invoice, admin_invoice: {amount_due: @admin_invoice.amount_due, attempt_count: @admin_invoice.attempt_count, attempted: @admin_invoice.attempted, charge_id: @admin_invoice.charge_id, closed: @admin_invoice.closed, customer_id: @admin_invoice.customer_id, date: @admin_invoice.date, description: @admin_invoice.description, livemode: @admin_invoice.livemode, next_payment_attempt: @admin_invoice.next_payment_attempt, payment_succeeded: @admin_invoice.payment_succeeded, period_end: @admin_invoice.period_end, period_start: @admin_invoice.period_start, stripe_id: @admin_invoice.stripe_id, subscription_id: @admin_invoice.subscription_id, subtotal: @admin_invoice.subtotal, tax: @admin_invoice.tax, tax_percent: @admin_invoice.tax_percent, total: @admin_invoice.total}
      assert_response :missing
      @admin_invoice.reload
      assert_equal original_invoice_amount, @admin_invoice.amount_due
    end
  end

  test 'nobody should destroy invoice' do
    assert_raises(AbstractController::ActionNotFound) do
      assert_difference('Charge.count', 0) do
        delete :destroy, id: @invoice
      end
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@regular_user)
      assert_difference('Charge.count', 0) do
        delete :destroy, id: @regular_user_invoice
      end
      assert_response :missing
    end

    assert_raises(AbstractController::ActionNotFound) do
      log_in(@admin_user)
      assert_difference('Charge.count', 0) do
        delete :destroy, id: @admin_invoice
      end
      assert_response :missing
    end
  end
end
