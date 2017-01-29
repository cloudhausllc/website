require 'test_helper'
include SessionsHelper

class Payment::DonationsControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)
    @donation = payments(:small_donation)
  end

  teardown do
    log_out
    StripeMock.stop
  end

  test "admin should get payment donations index" do
    log_in(@admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:donations)
  end

  test "regular user should not get payment donations index " do
    log_in(@regular_user)
    get :index
    assert_nil assigns(:donations)
    assert_redirected_to root_path
  end

  test "anon should not get payment donations index" do
    get :index
    assert_nil assigns(:donations)
    assert_redirected_to root_path
  end

  test "should get new payment donation" do
    get :new
    assert_response :success
  end

  test "should create payment donation" do
    token = StripeMock.generate_card_token
    @donation.stripe_token = token

    assert_difference('Payment.count') do
      post :create, payment_donation: {amount: @donation.amount, notes: @donation.notes, stripe_token: @donation.stripe_token, user_id: @donation.user_id}
    end

    assert_response :success
  end

  test "anon should not get donation thank you directly" do
    get :thank_you
    assert_redirected_to new_payment_donation_path
  end

  test "user should not get donation thank you directly" do
    log_in(@regular_user)
    get :thank_you
    assert_redirected_to new_payment_donation_path
  end

  test "admin should not get donation thank you directly" do
    log_in(@admin_user)
    get :thank_you
    assert_redirected_to new_payment_donation_path
  end
end
