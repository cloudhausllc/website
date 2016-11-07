require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
  end

  teardown do
    log_out
    StripeMock.stop
  end

  test 'should get rules' do
    get :rules
    assert_response :success
  end

  test 'should get facilities' do
    get :facilities
    assert_response :success
  end

  test 'should get pricing' do
    get :pricing
    assert_response :success
  end

  test 'should get faq' do
    get :faq
    assert_response :success
  end
end
