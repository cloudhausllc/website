require 'test_helper'
include SessionsHelper

class PaymentTest < ActiveSupport::TestCase
  setup do
    @payment = payments(:small_payment)
  end

  test 'pretty type should be payment' do
    assert_equal @payment.pretty_type, 'Payment'
  end
end
