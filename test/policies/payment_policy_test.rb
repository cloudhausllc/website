require 'test_helper'

class PaymentPolicyTest < PolicyAssertions::Test
  def setup
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)
    @payment = payments(:small_payment)
    @available_actions = [:index]
  end

  def test_index
    #Only admin should be able to list donations.
    assert_permit @admin_user, Payment::Donation
    refute_permit @regular_user, Payment::Donation
    refute_permit nil, Payment::Donation
  end

  def test_strong_parameters
    plan_attributes = @payment.attributes
    available_params = []

    assert_strong_parameters(@admin_user, Plan, plan_attributes, available_params)
    assert_strong_parameters(@regular_user, Plan, plan_attributes, available_params)
    assert_strong_parameters(nil, Plan, plan_attributes, available_params)
  end
end