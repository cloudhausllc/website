require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test 'should log in user' do
    assert_nil session[:user_id]
    post :create, session: { email: @user[:email], password: 'test_user_password1'}
    assert_equal session[:user_id], @user[:id]
  end

  test 'should log out user' do
    assert_nil session[:user_id]
    post :create, session: { email: @user[:email], password: 'test_user_password1'}
    assert_equal session[:user_id], @user[:id]
    get :destroy
    assert_nil session[:user_id]
  end


end
