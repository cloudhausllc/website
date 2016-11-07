require 'test_helper'

class Asset::ToolsControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
    @asset_tool = asset_tools(:active_tool)
    @asset_tool_value = @asset_tool.value
    @new_asset_tool_value = @asset_tool.value+1

    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)
  end

  teardown do
    log_out
    StripeMock.stop
  end

  test 'all users types should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:asset_tools)

    log_in(@admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:asset_tools)

    log_in(@regular_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:asset_tools)
  end

  test 'admin should get new' do
    log_in(@admin_user)
    get :new
    assert_response :success
  end

  test 'regular user and anon should not get new' do
    get :new
    assert_redirected_to root_path

    log_in(@regular_user)
    get :new
    assert_redirected_to root_path
  end

  test 'admin should create asset_tool' do
    log_in(@admin_user)
    assert_difference('Asset::Tool.count') do
      post :create, asset_tool: {active: @asset_tool.active, model_number: @asset_tool.model_number, name: @asset_tool.name, notes: @asset_tool.notes, on_premises: @asset_tool.on_premises, quantity: @asset_tool.quantity, sqft: @asset_tool.sqft, url: @asset_tool.url, user_id: @asset_tool.user_id, value: @asset_tool.value}
    end

    assert_redirected_to asset_tool_path(assigns(:asset_tool))
  end

  test 'regular user and anon should not create asset_tool' do
    assert_difference('Asset::Tool.count', 0) do
      post :create, asset_tool: {active: @asset_tool.active, model_number: @asset_tool.model_number, name: @asset_tool.name, notes: @asset_tool.notes, on_premises: @asset_tool.on_premises, quantity: @asset_tool.quantity, sqft: @asset_tool.sqft, url: @asset_tool.url, user_id: @asset_tool.user_id, value: @asset_tool.value}
    end

    assert_redirected_to root_path

    log_in(@regular_user)
    assert_difference('Asset::Tool.count', 0) do
      post :create, asset_tool: {active: @asset_tool.active, model_number: @asset_tool.model_number, name: @asset_tool.name, notes: @asset_tool.notes, on_premises: @asset_tool.on_premises, quantity: @asset_tool.quantity, sqft: @asset_tool.sqft, url: @asset_tool.url, user_id: @asset_tool.user_id, value: @asset_tool.value}
    end

    assert_redirected_to root_path
  end

  test 'all users should show asset_tool' do

    get :show, id: @asset_tool
    assert_response :success
    [@regular_user, @admin_user].each do |user|
      log_in(user)
      get :show, id: @asset_tool
      assert_response :success
    end
  end

  test 'admin should get edit' do
    log_in(@admin_user)
    get :edit, id: @asset_tool
    assert_response :success
  end

  test 'regular user and anon should not get edit' do
    get :edit, id: @asset_tool
    assert_redirected_to root_path

    log_in(@regular_user)
    get :edit, id: @asset_tool
    assert_redirected_to root_path
  end

  test 'admin should update asset_tool' do
    log_in(@admin_user)
    patch :update, id: @asset_tool, asset_tool: {value: @new_asset_tool_value, active: @asset_tool.active, model_number: @asset_tool.model_number, name: @asset_tool.name, notes: @asset_tool.notes, on_premises: @asset_tool.on_premises, quantity: @asset_tool.quantity, sqft: @asset_tool.sqft, url: @asset_tool.url, user_id: @asset_tool.user_id}
    assert_equal @new_asset_tool_value, @asset_tool.reload.value
    assert_redirected_to asset_tool_path(assigns(:asset_tool))
  end

  test 'regular user and anon should not update asset_tool' do
    patch :update, id: @asset_tool, asset_tool: {value: @new_asset_tool_value, active: @asset_tool.active, model_number: @asset_tool.model_number, name: @asset_tool.name, notes: @asset_tool.notes, on_premises: @asset_tool.on_premises, quantity: @asset_tool.quantity, sqft: @asset_tool.sqft, url: @asset_tool.url, user_id: @asset_tool.user_id}
    assert_equal @asset_tool_value, @asset_tool.reload.value
    assert_redirected_to root_path

    log_in(@regular_user)
    patch :update, id: @asset_tool, asset_tool: {value: @new_asset_tool_value, active: @asset_tool.active, model_number: @asset_tool.model_number, name: @asset_tool.name, notes: @asset_tool.notes, on_premises: @asset_tool.on_premises, quantity: @asset_tool.quantity, sqft: @asset_tool.sqft, url: @asset_tool.url, user_id: @asset_tool.user_id}
    assert_equal @asset_tool_value, @asset_tool.reload.value
    assert_redirected_to root_path
  end

  test 'admin should destroy asset_tool' do
    log_in(@admin_user)
    assert_difference('Asset::Tool.count', -1) do
      delete :destroy, id: @asset_tool
    end

    assert_redirected_to asset_tools_path
  end

  test 'regular user and anon should not destroy asset_tool' do
    assert_difference('Asset::Tool.count', 0) do
      delete :destroy, id: @asset_tool
    end

    assert_redirected_to root_path

    @regular_user
    assert_difference('Asset::Tool.count', 0) do
      delete :destroy, id: @asset_tool
    end

    assert_redirected_to root_path
  end
end
