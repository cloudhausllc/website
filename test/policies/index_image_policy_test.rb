require 'test_helper'

class IndexImagePolicyTest < PolicyAssertions::Test
  def setup
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @active_index_image = index_images(:active_image)
    @inactive_index_image = index_images(:inactive_image)

    @available_actions = [:index, :new, :create, :edit, :update, :destroy]
  end

  def test_index
    #Everyone should be able to get index.
    assert_permit @admin_user, IndexImage
    refute_permit @regular_user, IndexImage
    refute_permit nil, IndexImage
  end

  def test_show
    #Everyone should be able to show active images.
    assert_permit @admin_user, @active_index_image
    assert_permit @regular_user, @active_index_image
    assert_permit nil, @active_index_image

    #Only admin should be able to show inactive images.
    assert_permit @admin_user, @inactive_index_image
    refute_permit @regular_user, @inactive_index_image
    refute_permit nil, @inactive_index_image
  end

  def test_edit_and_update
    #Only admins should be able ot get edit and update
    assert_permit @admin_user, @active_index_image

    refute_permit @regular_user, @active_index_image
    refute_permit nil, @active_index_image
  end

  def test_destroy
    #Only admins should be able to destroy
    assert_permit @admin_user, @active_index_image

    refute_permit @regular_user, @active_index_image
    refute_permit nil, @active_index_image
  end

  def test_create_and_new
    #Only admins should be able to get to new and create
    assert_permit @admin_user, IndexImage

    refute_permit @regular_user, IndexImage
    refute_permit nil, IndexImage
  end

  def test_strong_parameters
    asset_tool_attributes = @active_index_image.attributes
    admin_params = [:id, :user_id, :image, :active, :caption, :url]
    regular_user_params = []
    anonymous_params = []

    assert_strong_parameters(@admin_user, IndexImage, asset_tool_attributes, admin_params)
    assert_strong_parameters(@regular_user, IndexImage, asset_tool_attributes, regular_user_params)
    assert_strong_parameters(nil, IndexImage, asset_tool_attributes, anonymous_params)
  end

end