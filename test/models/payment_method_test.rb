require 'test_helper'

class PaymentMethodTest < ActiveSupport::TestCase
  setup do
    StripeMock.start
    @valid_payment_method = payment_methods(:valid)
  end

  teardown do
    StripeMock.stop
  end

  test 'should be valid' do
    @valid_payment_method.valid?
  end

  test 'requires expiration month' do
    @valid_payment_method.exp_month = nil
    @valid_payment_method.save
    assert_not @valid_payment_method.valid?
  end

  test 'expiration month must be numeric' do
    @valid_payment_method.exp_month = 'ab'
    @valid_payment_method.save
    assert_not @valid_payment_method.valid?
  end

  test 'expiration month must be between 1 and 12' do
    [-1, 13, 0].each do |test_exp_month|
      @valid_payment_method.exp_month = test_exp_month
      @valid_payment_method.save
      assert_not @valid_payment_method.valid?
    end
  end

  test 'requires expiration year' do
    @valid_payment_method.exp_year = nil
    @valid_payment_method.save
    assert_not @valid_payment_method.valid?
  end

  test 'expiration year must be numeric' do
    @valid_payment_method.exp_year = 'ab'
    @valid_payment_method.save
    assert_not @valid_payment_method.valid?
  end

  test 'expiration year must be two digits' do
    @valid_payment_method.last4 = 200
    @valid_payment_method.save
    assert_not @valid_payment_method.valid?
  end

  test 'requires last 4' do
    @valid_payment_method.last4 = nil
    @valid_payment_method.save
    assert_not @valid_payment_method.valid?
  end

  test 'last 4 must be numeric' do
    @valid_payment_method.last4 = 'abcd'
    @valid_payment_method.save
    assert_not @valid_payment_method.valid?
  end

  test 'last 4 has to be 4 digits long' do
    [1, 10, 100, 10000].each do |test_last_4|
      @valid_payment_method.last4 = test_last_4
      @valid_payment_method.save
      assert_not @valid_payment_method.valid?
    end
  end

  test 'requires stripe token id' do
    @valid_payment_method.stripe_token_id = nil
    @valid_payment_method.save
    assert_not @valid_payment_method.valid?
  end

  test 'requires stripe card id' do
    @valid_payment_method.stripe_card_id = nil
    @valid_payment_method.save
    assert_not @valid_payment_method.valid?
  end
end
