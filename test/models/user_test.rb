require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: 'Test',
                     last_name: 'User',
                     email: 'test_user@cloudhaus.org',
                     password: 'foobar123', password_confirmation: 'foobar123')
  end

  test 'should be valid' do
    @user.valid?
  end

  test 'email address should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email address should be saved lowercase' do
    mixed_case_email = 'TEST_user@cloudhaus.org'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'email should be valid' do
    bad_email = 'test'
    @user.email = bad_email
    @user.save
    assert_not @user.valid?
  end

  test 'last name is required' do
    @user.last_name = ' '
    @user.save
    assert_not @user.valid?
  end

  test 'first name is required' do
    @user.first_name = ' '
    @user.save
    assert_not @user.valid?
  end

  test 'first name maximum length' do
    @user.first_name = 'a'*51
    @user.save
    assert_not @user.valid?
  end

  test 'last name maximum length' do
    @user.last_name = 'a'*51
    @user.save
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end


end
