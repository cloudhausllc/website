require 'test_helper'

class PaymentMethodPolicyTest < PolicyAssertions::Test
  def setup
    @admin_user = users(:payment_method_admin_user)
    @regular_user = users(:payment_method_regular_user)

    @admin_payment_method = payment_methods(:payment_method_admin)
    @payment_method = payment_methods(:payment_method_regular)

    @available_actions = [:create, :destroy]
  end

  def test_destroy
    #Admins should be able to destroy their payment method and other payment methods.
    assert_permit @admin_user, @admin_payment_method
    assert_permit @admin_user, @payment_method

    #Regular users can only destroy their payment methods.
    assert_permit @regular_user, @payment_method
    refute_permit @regular_user, @admin_payment_method

    #Anon are not permitted to payment plans.
    refute_permit nil, @payment_method
    refute_permit nil, @admin_payment_method
  end

  def test_create
    #Admins and regular users can create payment methods.
    assert_permit @admin_user, PaymentMethod
    assert_permit @regular_user, PaymentMethod
    refute_permit nil, PaymentMethod
  end

  def test_strong_parameters
    payment_method_params = @payment_method.attributes
    admin_params = [:user_id, :user_id, :brand, :exp_month, :exp_year, :last4, :stripe_token_id, :stripe_card_id]
    regular_user_params = [:user_id, :user_id, :brand, :exp_month, :exp_year, :last4, :stripe_token_id, :stripe_card_id]
    anonymous_params = []

    assert_strong_parameters(@admin_user, PaymentMethod, payment_method_params, admin_params)

    assert_strong_parameters(@regular_user, PaymentMethod, payment_method_params, regular_user_params)

    assert_strong_parameters(nil, PaymentMethod, payment_method_params, anonymous_params)
  end

end