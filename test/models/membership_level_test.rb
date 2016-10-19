require 'test_helper'

class MembershipLevelTest < ActiveSupport::TestCase
  def setup
    @membership_level = MembershipLevel.new(name: 'New Membership Level', monthly_payment: 100.00)
    @ml_no_name = MembershipLevel.new(monthly_payment: 100.00)
    @ml_no_monthly_payment = MembershipLevel.new(name: 'New Membership Level')
  end

  test 'should be valid' do
    @membership_level.valid?
  end

  test 'no name should be invalid' do
    assert_not @ml_no_name.valid?
  end

  test 'no monthly payment should be invalid' do
    assert_not @ml_no_monthly_payment.valid?
  end

  test 'monthly payment should be number' do
    @membership_level.monthly_payment = 'aaa'
    @membership_level.save
    assert_not @membership_level.valid?
  end

end
