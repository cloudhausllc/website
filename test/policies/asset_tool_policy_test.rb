require 'test_helper'

class AssetToolPolicyTest < PolicyAssertions::Test
  def setup
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @active_tool_on_prem = asset_tools(:active_tool_on_premises)
    @inactive_tool_on_prem = asset_tools(:inactive_tool_on_premises)

    @active_tool_off_prem = asset_tools(:active_tool_off_premises)
    @inactive_tool_off_prem = asset_tools(:inactive_tool_on_premises)


    @available_actions = [:index, :new, :create, :edit, :update, :destroy]
  end

  def test_index
    #Everyone should be able to get index.
    assert_permit @admin_user, Asset::Tool
    assert_permit @regular_user, Asset::Tool
    assert_permit nil, Asset::Tool
  end

  def test_edit_and_update
    #Only admins should be able ot get edit and update
    assert_permit @admin_user, @active_tool_on_prem
    refute_permit @regular_user, @active_tool_on_prem
    refute_permit nil, @active_tool_on_prem
  end

  def test_destroy
    #Only admins should be able to destroy
    assert_permit @admin_user, @active_tool_on_prem

    refute_permit @regular_user, @active_tool_on_prem
    refute_permit nil, @active_tool_on_prem
  end

  def test_show
    #Admins can show any tool.
    assert_permit @admin_user, @active_tool_on_prem
    assert_permit @admin_user, @inactive_tool_on_prem
    assert_permit @admin_user, @active_tool_off_prem
    assert_permit @admin_user, @inactive_tool_off_prem

    #Regular members and anon can only show active tools that are on premises.
    assert_permit @regular_user, @active_tool_on_prem
    refute_permit @regular_user, @inactive_tool_on_prem
    refute_permit @regular_user, @active_tool_off_prem
    refute_permit @regular_user, @inactive_tool_off_prem

    assert_permit nil, @active_tool_on_prem
    refute_permit nil, @inactive_tool_on_prem
    refute_permit nil, @active_tool_off_prem
    refute_permit nil, @inactive_tool_off_prem
  end

  def test_create_and_new
    #Only admins should be able to get to new and create
    assert_permit @admin_user, Asset::Tool

    refute_permit @regular_user, Asset::Tool
    refute_permit nil, Asset::Tool
  end

  def test_strong_parameters
    asset_tool_attributes = @active_tool_on_prem.attributes
    admin_params = [:active, :on_premises, :value, :name, :user_id, :quantity, :url, :sqft, :model_number, :notes]
    regular_user_params = []
    anonymous_params = []

    assert_strong_parameters(@admin_user, Asset::Tool, asset_tool_attributes, admin_params)
    assert_strong_parameters(@regular_user, Asset::Tool, asset_tool_attributes, regular_user_params)
    assert_strong_parameters(nil, Asset::Tool, asset_tool_attributes, anonymous_params)
  end

end