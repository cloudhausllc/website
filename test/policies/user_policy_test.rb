require 'test_helper'

class UserPolicyTest < PolicyTest
  def setup
    @regular_user = users(:regular_user)
    @admin_user = users(:admin_user)
    @available_actions = [:index, :new, :create, :edit, :update, :destroy]
  end

  test 'admin should be able to get users index' do
    assert_permit(@admin_user, :user, :index)
  end

  test "admin user" do
    assert_permissions(@admin_user, @user, [:index, :edit, :update, :destroy],
                       index: true,
                       edit: true,
                       update: true,
                       destroy: true)

    assert_permissions(@admin_user, nil, [:create, :new],
                       create: true,
                       new: true)
  end

  test "user on his own record" do
    assert_permissions(@regular_user, @regular_user, @available_actions,
                       create: false,
                       index: false,
                       new: false,
                       edit: true,
                       update: true,
                       destroy: false)
  end

  test "random person on user" do
    assert_permissions(nil, @regular_user, [:index, :edit, :update, :destroy],
                       index: false,
                       edit: false,
                       update: false,
                       destroy: false)

    assert_permissions(nil, nil, [:create, :new],
                       create: true,
                       new: true)
  end
end