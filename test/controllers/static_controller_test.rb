require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  setup do
  end

  test "should get rules" do
    get :rules
    assert_response :success
  end

  test "should get facilities" do
    get :facilities
    assert_response :success
  end
end
