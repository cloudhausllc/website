require 'test_helper'
include SessionsHelper

class UsersControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
    @user = users(:user1)
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)
    @admin_selectable_only_plan = plans(:admin_selectable_only_plan)
  end

  teardown do
    log_out
    StripeMock.stop
  end

  test 'admin should get index' do
    log_in(@admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'regular user should get redirected' do
    log_in(@regular_user)
    get :index
    assert_nil assigns(:users)
    assert_redirected_to root_path
  end

  test 'anonymous user should get redirected' do
    assert_equal false, logged_in?
    get :index
    assert_nil assigns(:users)
    assert_redirected_to root_path
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {email: 'test_email@cloudhaus.org', first_name: @user.first_name, last_name: @user.last_name,
                           password: 'test_password', password_confirmation: 'test_password'}
    end

    assert_redirected_to login_path
  end

  # test 'admins can show users' do
  #   log_in(@admin_user)
  #   get :show, id: @user
  #   assert_response :success
  # end
  #
  # test 'regular users can show self' do
  #   log_in(@regular_user)
  #   get :show, id: @regular_user
  #   assert_response :success
  # end
  #
  # test 'regular users can not show others' do
  #   log_in(@regular_user)
  #   get :show, id: @user
  #   assert_redirected_to root_path
  # end
  #
  # test 'anonymous can not show users' do
  #   get :show, id: @user
  #   assert_redirected_to root_path
  # end

  test 'admin should get edit' do
    log_in(@admin_user)
    get :edit, id: @user
    assert_response :success
  end

  test 'regular users should get edit for self' do
    log_in(@regular_user)
    get :edit, id: @regular_user
    assert_response :success
  end

  test 'regular users can\'t get edit for others' do
    log_in(@regular_user)
    get :edit, id: @user
    assert_redirected_to root_path
  end

  test 'anonymous can\'t get edit' do
    get :edit, id: @user
    assert_redirected_to root_path
  end

  test 'admin should see admin only plans for self' do
    log_in(@admin_user)
    get :edit, id: @admin_user
    assert_includes assigns(:plans), @admin_selectable_only_plan
  end

  test 'admin should see admin only plans for other' do
    log_in(@admin_user)
    get :edit, id: @regular_user
    assert_includes assigns(:plans), @admin_selectable_only_plan
  end

  test 'regular user should not see admin only plans for self' do
    log_in(@regular_user)
    get :edit, id: @regular_user
    assert_not_includes assigns(:plans), @admin_selectable_only_plan
  end

  test 'admin should be able to update user' do
    log_in(@admin_user)
    patch :update, id: @user, user: {email: @user.email, first_name: 'NewFirstName', id: @user.id, last_name: @user.last_name}

    assert_equal User.find(@user[:id]).first_name, 'NewFirstName'
    assert_redirected_to edit_user_path(assigns(:user))
  end

  test 'regular users should be able to update self' do
    log_in(@regular_user)
    patch :update, id: @regular_user, user: {email: @regular_user.email, first_name: 'NewFirstName', id: @regular_user.id, last_name: @regular_user.last_name}

    assert_equal @regular_user.reload.first_name, 'NewFirstName'
    assert_redirected_to edit_user_path(assigns(:user))
  end

  test 'regular users should not be able to update others' do
    log_in(@regular_user)
    old_first_name = @user.first_name
    patch :update, id: @user, user: {email: @user.email, first_name: 'NewFirstName', id: @user.id, last_name: @user.last_name}

    assert_equal @user.reload.first_name, old_first_name
    assert_redirected_to root_path
  end

  test 'anonymous should not be able to update others' do
    old_first_name = @user.first_name
    patch :update, id: @user, user: {email: @user.email, first_name: 'NewFirstName', id: @user.id, last_name: @user.last_name}
    assert_equal @user.reload.first_name, old_first_name
    assert_redirected_to root_path
  end

  test 'admin should be able to destroy user' do
    log_in(@admin_user)
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

  test 'regular users should not be able to destroy self' do
    log_in(@regular_user)
    assert_difference('User.count', 0) do
      delete :destroy, id: @regular_user
    end

    assert_redirected_to root_path
  end

  test 'regular users should not be able to destroy other user' do
    log_in(@regular_user)
    assert_difference('User.count', 0) do
      delete :destroy, id: @user
    end

    assert_redirected_to root_path
  end

  test 'anonymous users should not be able to destroy user' do
    assert_difference('User.count', 0) do
      delete :destroy, id: @user
    end

    assert_redirected_to root_path
  end

  test 'admin should be able to assign admin only plan to self' do
    use_stripe_variables
    log_in(@admin_plan_user)

    patch :update, id: @admin_plan_user, user: {plan_id: @admin_selectable_only_plan.id}

    @admin_plan_user.reload
    assert_equal @admin_plan_user.plan_id, @admin_selectable_only_plan[:id]
    assert_redirected_to edit_user_path(assigns(:user))
  end

  test 'admin should be able to assign admin only plan to other' do
    use_stripe_variables
    log_in(@admin_plan_user)

    patch :update, id: @regular_plan_user, user: {plan_id: @admin_selectable_only_plan.id}

    @regular_plan_user.reload
    assert_equal @regular_plan_user.plan_id, @admin_selectable_only_plan[:id]
    assert_redirected_to edit_user_path(assigns(:user))
  end

  test 'regular user should not be able to assign admin only plan to self' do
    use_stripe_variables
    log_in(@regular_plan_user)

    patch :update, id: @regular_plan_user, user: {plan_id: @admin_selectable_only_plan.id}

    @regular_plan_user.reload
    assert_not_equal @regular_plan_user.plan_id, @admin_selectable_only_plan[:id]
    # assert_redirected_to edit_user_path(assigns(:user))
    assert :success
  end

  test 'regular user should not be able to assign admin only plan to other' do
    use_stripe_variables
    log_in(@regular_plan_user)

    patch :update, id: @second_regular_plan_user, user: {plan_id: @admin_selectable_only_plan.id}

    @second_regular_plan_user.reload
    assert_not_equal @second_regular_plan_user.plan_id, @admin_selectable_only_plan[:id]
    assert_redirected_to root_path
  end

  private

  def use_stripe_variables
    @admin_plan_user = users(:payment_method_admin_user) #Use for anything needing Stripe
    @regular_plan_user = users(:payment_method_regular_user) #Use for anything needing Stripe
    @second_regular_plan_user = users(:second_payment_method_regular_user) #Use for anything needing Stripe


    [@admin_plan_user, @regular_plan_user, @second_regular_plan_user].each do |user|
      log_in(user)
      current_pm = user.payment_methods.first
      user.payment_methods.create({
                                      brand: current_pm.brand,
                                      exp_month: current_pm.exp_month,
                                      exp_year: current_pm.exp_year,
                                      last4: current_pm.last4,
                                      stripe_token_id: StripeMock.generate_card_token
                                  })
      log_out
    end

    stripe_helper = StripeMock.create_test_helper
    stripe_helper.create_plan(
        id: @admin_selectable_only_plan[:stripe_plan_id],
        amount: @admin_selectable_only_plan[:stripe_plan_amount],
        interval: @admin_selectable_only_plan[:stripe_plan_interval],
        name: @admin_selectable_only_plan[:stripe_plan_name])
  end
end
