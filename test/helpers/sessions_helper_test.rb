require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    StripeMock.start
    @user = users(:user1)
  end

  teardown do
    log_out
    StripeMock.stop
  end

  test 'should log in user' do
    log_in(@user)
    assert_equal session[:user_id], @user[:id]
  end

  test 'should log out user' do
    log_in(@user)
    assert_equal session[:user_id], @user[:id]
    log_out
    assert_nil session[:user_id]
    assert_nil current_user
  end

  test 'should return current logged in user user' do
    log_in(@user)
    assert_equal current_user, @user
  end

  test 'should return true if a user is logged in' do
    log_in(@user)
    assert_equal logged_in?, true
  end

  test 'should return false if a user is not logged in' do
    log_in(@user)
    log_out
    assert_equal logged_in?, false
  end
end