require 'test_helper'

class UserPolicyTest < PolicyAssertions::Test
  def setup
    @regular_user = users(:regular_user)
    @user1 = users(:user1)
    @admin_user = users(:admin_user)
    @available_actions = [:index, :new, :create, :edit, :update, :destroy]
  end

  def test_index
    #Only admins should be able to get index.
    assert_permit @admin_user, User
    refute_permit @regular_user, User
    refute_permit nil, User
  end

  def test_edit_and_update
    #Admins can edit self and others.
    assert_permit @admin_user, @admin_user
    assert_permit @admin_user, @regular_user

    #Regular users can edit self, but not others.
    assert_permit @regular_user, @regular_user
    refute_permit @regular_user, @user1

    #Anon should not be able to edit anyone.
    refute_permit nil, @regular_user
  end

  def test_destroy
    #Admins should be able to destroy records other than their own.
    refute_permit @admin_user, @admin_user
    assert_permit @admin_user, @regular_user

    #Regular users are not permitted to destroy users.
    refute_permit @regular_user, @regular_user
    refute_permit @regular_user, @user1

    #Anon are not permitted to destroy users.
    refute_permit nil, @regular_user
  end

  def test_create_and_new
    #Admins and anon should be able to create a user.
    assert_permit @admin_user, User
    refute_permit @regular_user, User
    assert_permit nil, User
  end

  def test_strong_parameters
    user_attributes = @regular_user.attributes
    admin_params = [:id, :first_name, :last_name, :email, :password, :active, :admin, :membership_level]
    regular_user_params = [:id, :first_name, :last_name, :email, :password]
    anonymous_params = [:id, :first_name, :last_name, :email, :password]

    assert_strong_parameters(@admin_user, User, user_attributes, admin_params)

    assert_strong_parameters(@regular_user, User, user_attributes, regular_user_params)

    assert_strong_parameters(nil, User, user_attributes, anonymous_params)
  end

end