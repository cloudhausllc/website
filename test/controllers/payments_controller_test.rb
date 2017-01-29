require 'test_helper'
include SessionsHelper

class PaymentsControllerTest < ActionController::TestCase
  setup do
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)
    @payment = payments(:small_payment)

    StripeMock.start
  end

  teardown do
    StripeMock.stop
    log_out
  end

  test "admin should get payment index" do
    log_in(@admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  test "regular member should not get payment index" do
    log_in(@regular_user)
    get :index
    assert_nil assigns(:payments)
    assert_redirected_to root_path
  end

  test "anon should not get payment index" do
    get :index
    assert_nil assigns(:payments)
    assert_redirected_to root_path
  end


end
