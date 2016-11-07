require 'test_helper'

class IndexControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
  end

  teardown do
    log_out
    StripeMock.stop
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end
