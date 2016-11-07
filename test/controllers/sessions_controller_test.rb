require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
    @user = users(:user1)
    @active_user = users(:active_user)
    @inactive_user = users(:inactive_user)
  end

  teardown do
    log_out
    StripeMock.stop
  end

  test 'active users should be able to log in' do
    assert_nil session[:user_id]
    post :create, session: { email: @active_user[:email], password: 'password'}
    assert_equal @active_user[:id], session[:user_id]
  end

  test 'should log out user' do
    assert_nil session[:user_id]
    post :create, session: { email: @active_user[:email], password: 'password'}
    assert_equal @active_user[:id], session[:user_id]
    get :destroy
    assert_nil session[:user_id]
  end

  test 'inactive users should not be able to log in' do
    assert_nil session[:user_id]
    post :create, session: {email: @inactive_user[:email], password: 'password'}

    assert_nil session[:user_id]
    assert_redirected_to login_path
  end

end
