require 'test_helper'
include SessionsHelper

class MembershipLevelsControllerTest < ActionController::TestCase
  setup do
      @admin_user = users(:admin_user)
      @regular_user = users(:regular_user)
      @membership_level = membership_levels(:one)
  end

  teardown do
    log_out
  end

  test 'admin should get list of membership levels' do
    log_in(@admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:membership_levels)
  end

  test 'regular user should not list membership levels' do
    log_in(@regular_user)
    get :index
    assert_nil assigns(:membership_levels)
    assert_redirected_to root_path
  end

  test 'anonymous user should not list membership levels' do
    assert_equal false, logged_in?
    get :index
    assert_nil assigns(:membership_levels)
    assert_redirected_to root_path
  end

  test 'admin should get new membership level' do
    log_in(@admin_user)
    get :new
    assert_response :success
    assert_not_nil assigns(:membership_level)
  end

  test 'regular user should get redirected on new membership level' do
    log_in(@regular_user)
    get :new
    assert_nil assigns(:membership_level)
    assert_redirected_to root_path
  end

  test 'anonymous user should get redirected on new membership level' do
    assert_equal false, logged_in?
    get :new
    assert_nil assigns(:membership_level)
    assert_redirected_to root_path
  end

  test 'should create membership levels' do
    log_in(@admin_user)
    assert_difference('MembershipLevel.count') do
      post :create, membership_level: {name: 'New Membership Level', monthly_payment: 100.00}
    end

    assert_redirected_to membership_levels_path
  end

  test 'regular user should not create membership levels' do
    log_in(@regular_user)
    assert_difference('MembershipLevel.count', 0) do
      post :create, membership_level: {name: 'New Membership Level', monthly_payment: 100.00}
    end

    assert_redirected_to root_path
  end

  test 'anonymous user should not create membership levels' do
    assert_equal false, logged_in?
    assert_difference('MembershipLevel.count', 0) do
      post :create, membership_level: {name: 'New Membership Level', monthly_payment: 100.00}
    end

    assert_redirected_to root_path
  end

  test 'admins can show membership levels' do
    log_in(@admin_user)
    get :show, id: @membership_level
    assert_response :success
  end

  test 'regular users can not see membership levels' do
    log_in(@regular_user)
    get :show, id: @membership_level
    assert_redirected_to root_path
  end

  test 'anonymous users can not see membership levels' do
    assert_equal false, logged_in?
    get :show, id: @membership_level
    assert_redirected_to root_path
  end

  test 'admin should get membership level edit' do
    log_in(@admin_user)
    get :edit, id: @membership_level
    assert_not_nil assigns(:membership_level)
    assert_response :success
  end

  test 'regular users not get membership level edit' do
    log_in(@regular_user)
    get :edit, id: @membership_level
    assert_redirected_to root_path
  end

  test 'anonymous users not get membership level edit' do
    assert_equal false, logged_in?
    get :edit, id: @membership_level
    assert_redirected_to root_path
  end

  test 'admin should be able to update membership level' do
    log_in(@admin_user)
    patch :update, id: @membership_level, membership_level: {monthly_payment: 150}

    assert_equal MembershipLevel.find(@membership_level[:id]).monthly_payment, 150
    assert_redirected_to membership_level_path(assigns(:membership_level))
  end


  test 'regular users should not be able to update membership level' do
    log_in(@regular_user)
    old_monthly_payment = @membership_level.monthly_payment
    patch :update, id: @membership_level, membership_level: {monthly_payment: 150}

    assert_equal @membership_level.reload.monthly_payment, old_monthly_payment
    assert_redirected_to root_path
  end

  test 'anonymous users should not be able to update membership level' do
    assert_equal false, logged_in?
    old_monthly_payment = @membership_level.monthly_payment
    patch :update, id: @membership_level, membership_level: {monthly_payment: 150}

    assert_equal @membership_level.reload.monthly_payment, old_monthly_payment
    assert_redirected_to root_path
  end

  test 'admin should be able to destroy membership level' do
    log_in(@admin_user)
    assert_difference('MembershipLevel.count', -1) do
      delete :destroy, id: @membership_level
    end

    assert_redirected_to membership_levels_path
  end

  test 'regular users should not be able to destroy membership level' do
    log_in(@regular_user)
    assert_difference('MembershipLevel.count', 0) do
      delete :destroy, id: @membership_level
    end

    assert_redirected_to root_path
  end

  test 'anonymous users should not be able to destroy membership level' do
    assert_equal false, logged_in?
    assert_difference('MembershipLevel.count', 0) do
      delete :destroy, id: @membership_level
    end

    assert_redirected_to root_path
  end

end
