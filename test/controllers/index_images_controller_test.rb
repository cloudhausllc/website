require 'test_helper'

class IndexImagesControllerTest < ActionController::TestCase
  setup do
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @active_index_image = index_images(:active_image)
    @inactive_index_image = index_images(:inactive_image)

    @old_index_image_active = @active_index_image.active
    @new_index_image_active = !@active_index_image.active

    @test_image = fixture_file_upload('test_image.png', 'image/png')
  end

  teardown do
    log_out
  end

  test 'admin should get index' do
    log_in(@admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:index_images)
  end

  test 'regular user should not get index' do
    log_in(@regular_user)
    get :index
    assert_redirected_to root_path
    assert_nil assigns(:index_images)
  end

  test 'anon user should not get index' do
    get :index
    assert_redirected_to root_path
    assert_nil assigns(:index_images)
  end

  test 'admin should get new' do
    log_in(@admin_user)
    get :new
    assert_response :success
  end

  test 'regular user should not get new' do
    log_in(@regular_user)
    get :new
    assert_redirected_to root_path
  end

  test 'anon user should not get new' do
    get :new
    assert_redirected_to root_path
  end

  test 'admin user should create index_image' do
    log_in(@admin_user)
    assert_difference('IndexImage.count', 1) do
      post :create, index_image: {active: @active_index_image.active, image: @test_image, user_id: @active_index_image.user_id}
    end

    assert_redirected_to index_image_path(assigns(:index_image))
  end

  test 'regular user should not create index_image' do
    log_in(@regular_user)
    assert_difference('IndexImage.count', 0) do
      post :create, index_image: {active: @active_index_image.active, image: @test_image, user_id: @active_index_image.user_id}
    end

    assert_redirected_to root_path
  end

  test 'anon user should not create index_image' do
    assert_difference('IndexImage.count', 0) do
      post :create, index_image: {active: @active_index_image.active, image: @test_image, user_id: @active_index_image.user_id}
    end

    assert_redirected_to root_path
  end


  test 'admin should show active index_image' do
    log_in(@admin_user)
    get :show, id: @active_index_image
    assert_response :success
  end

  test 'regular user should show active index_image' do
    log_in(@regular_user)
    get :show, id: @active_index_image
    assert_response :success
  end

  test 'anon user should show active index_image' do
    get :show, id: @active_index_image
    assert_response :success
  end

  test 'admin should show inactive index_image' do
    log_in(@admin_user)
    get :show, id: @inactive_index_image
    assert_response :success
  end

  test 'regular user should not show inactive index_image' do
    log_in(@regular_user)
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: @inactive_index_image
    end
  end

  test 'anon user should not show in active index_image' do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: @inactive_index_image
    end
  end


  test 'admin should get edit' do
    log_in(@admin_user)
    get :edit, id: @active_index_image
    assert_response :success
  end

  test 'regular user should not get not edit' do
    log_in(@regular_user)
    get :edit, id: @active_index_image
    assert_redirected_to root_path
  end

  test 'anon user should not get not edit' do
    get :edit, id: @active_index_image
    assert_redirected_to root_path
  end

  test 'should update index_image' do
    log_in(@admin_user)
    patch :update, id: @active_index_image, index_image: {active: @new_index_image_active}
    assert_equal @active_index_image.reload.active, @new_index_image_active
    assert_redirected_to index_image_path(assigns(:index_image))
  end

  test 'regular user should not update index_image' do
    log_in(@regular_user)
    patch :update, id: @active_index_image, index_image: {active: @new_index_image_active}
    assert_equal @active_index_image.reload.active, @old_index_image_active
    assert_redirected_to root_path
  end

  test 'anon user should not update index_image' do
    patch :update, id: @active_index_image, index_image: {active: @new_index_image_active}
    assert_equal @active_index_image.reload.active, @old_index_image_active
    assert_redirected_to root_path
  end

  test 'admin should destroy index_image' do
    log_in(@admin_user)
    assert_difference('IndexImage.count', -1) do
      delete :destroy, id: @active_index_image
    end

    assert_redirected_to index_images_path
  end

  test 'regular user should not destroy index_image' do
    assert_difference('IndexImage.count', 0) do
      delete :destroy, id: @active_index_image
    end

    assert_redirected_to root_path
  end

  test 'anon user should not destroy index_image' do
    assert_difference('IndexImage.count', 0) do
      delete :destroy, id: @active_index_image
    end

    assert_redirected_to root_path
  end


end
