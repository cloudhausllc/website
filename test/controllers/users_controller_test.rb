require 'test_helper'
include SessionsHelper

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:user1)
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)
  end

  teardown do
    log_out
  end

  test 'admin should get index' do
    log_in(@admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'regular user should get redirected' do
    log_in(@regular_user)
    get :index
    assert_nil assigns(:users)
    assert_redirected_to root_path
  end

  test 'anonymous user should get redirected' do
    assert_equal false, logged_in?
    get :index
    assert_nil assigns(:users)
    assert_redirected_to root_path
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {email: 'test_email@cloudhaus.org', first_name: @user.first_name, last_name: @user.last_name,
                           password: 'test_password', password_confirmation: 'test_password'}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test 'admins can show users' do
    log_in(@admin_user)
    get :show, id: @user
    assert_response :success
  end

  test 'regular users can show self' do
    log_in(@regular_user)
    get :show, id: @regular_user
    assert_response :success
  end

  test 'regular users can not show others' do
    log_in(@regular_user)
    get :show, id: @user
    assert_redirected_to root_path
  end

  test 'anonymous can not show users' do
    get :show, id: @user
    assert_redirected_to root_path
  end

  test 'admin should get edit' do
    log_in(@admin_user)
    get :edit, id: @user
    assert_response :success
  end

  test 'regular users should get edit for self' do
    log_in(@regular_user)
    get :edit, id: @regular_user
    assert_response :success
  end

  test 'regular users can\'t get edit for others' do
    log_in(@regular_user)
    get :edit, id: @user
    assert_redirected_to root_path
  end

  test 'anonymous can\'t get edit' do
    get :edit, id: @user
    assert_redirected_to root_path
  end

  test 'admin should be able to update user' do
    log_in(@admin_user)
    patch :update, id: @user, user: {email: @user.email, first_name: 'NewFirstName', id: @user.id, last_name: @user.last_name}

    assert_equal User.find(@user[:id]).first_name, 'NewFirstName'
    assert_redirected_to user_path(assigns(:user))
  end

  test 'regular users should be able to update self' do
    log_in(@regular_user)
    patch :update, id: @regular_user, user: {email: @regular_user.email, first_name: 'NewFirstName', id: @regular_user.id, last_name: @regular_user.last_name}

    assert_equal @regular_user.reload.first_name, 'NewFirstName'
    assert_redirected_to user_path(assigns(:user))
  end

  test 'regular users should not be able to update others' do
    log_in(@regular_user)
    old_first_name = @user.first_name
    patch :update, id: @user, user: {email: @user.email, first_name: 'NewFirstName', id: @user.id, last_name: @user.last_name}

    assert_equal @user.reload.first_name, old_first_name
    assert_redirected_to root_path
  end

  test 'anonymous should not be able to update others' do
    old_first_name = @user.first_name
    patch :update, id: @user, user: {email: @user.email, first_name: 'NewFirstName', id: @user.id, last_name: @user.last_name}
    assert_equal @user.reload.first_name, old_first_name
    assert_redirected_to root_path
  end

  test 'admin should be able to destroy user' do
    log_in(@admin_user)
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

  test 'regular users should not be able to destroy self' do
    log_in(@regular_user)
    assert_difference('User.count', 0) do
      delete :destroy, id: @regular_user
    end

    assert_redirected_to root_path
  end

  test 'regular users should not be able to destroy other user' do
    log_in(@regular_user)
    assert_difference('User.count', 0) do
      delete :destroy, id: @user
    end

    assert_redirected_to root_path
  end

  test 'anonymouse users should not be able to destroy user' do
    assert_difference('User.count', 0) do
      delete :destroy, id: @user
    end

    assert_redirected_to root_path
  end
end
