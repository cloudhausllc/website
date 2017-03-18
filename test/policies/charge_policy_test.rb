require 'test_helper'

class ChargePolicyTest < PolicyAssertions::Test
  def setup
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @admin_charge = charges(:admin_charge)
    @regular_user_charge = charges(:regular_user_charge)

    @available_actions = [:show]
  end

  def test_index
    #Nobody should be able to get index.
    refute_permit @admin_user, Charge
    refute_permit @regular_user, Charge
    refute_permit nil, Charge
  end

  def test_show
    #Admin can show any charges
    assert_permit @admin_user, @admin_charge
    assert_permit @admin_user, @regular_user_charge

    #Regular user can only show own charges
    refute_permit @regular_user, @admin_charge
    @regular_user_charge.update!(customer_id: @regular_user.stripe_customer_id)
    assert_permit @regular_user, @regular_user_charge

    #Anon can't show any charges
    refute_permit nil, @admin_charge
    refute_permit nil, @regular_user_charge
  end

  def test_edit_and_update
    #Nobody should be able to get edit and update.
    refute_permit @admin_user, Charge
    refute_permit @regular_user, Charge
    refute_permit nil, Charge
  end

  def test_destroy
    #Nobody should be able to destroy.
    refute_permit @admin_user, Charge
    refute_permit @regular_user, Charge
    refute_permit nil, Charge
  end

  def test_create_and_new
    #Nobody should be able to get create and new.
    refute_permit @admin_user, Charge
    refute_permit @regular_user, Charge
    refute_permit nil, Charge
  end

  def test_strong_parameters
    charge_attributes = @admin_charge.attributes
    admin_params = []
    regular_user_params = []
    anonymous_params = []

    assert_strong_parameters(@admin_user, Charge, charge_attributes, admin_params)
    assert_strong_parameters(@regular_user, Charge, charge_attributes, regular_user_params)
    assert_strong_parameters(nil, Charge, charge_attributes, anonymous_params)
  end

end