require 'test_helper'

class PaymentMethodsControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
    @user = users(:regular_user)
    @user1 = users(:user1)
    @admin_user = users(:admin_user)

    @valid_payment_method = {
        exp_month: 10,
        exp_year: 2020,
        card_number: '4242424242424242',
        cvc: '123',
    }

  end

  teardown do
    log_out
    StripeMock.stop
  end

  test 'should create payment method' do
    log_in(@user)

    assert_nothing_raised do
      token = Stripe::Token.create(
          :card => {
              :number => @valid_payment_method[:card_number],
              :exp_month => @valid_payment_method[:exp_month],
              :exp_year => @valid_payment_method[:exp_year],
              :cvc => @valid_payment_method[:cvc]
          },
      )

      assert_difference('PaymentMethod.count') do
        post :create, payment_method: {
            brand: token.card.brand, exp_month: token.card.exp_month,
            exp_year: token.card.exp_year, last4: token.card.last4,
            stripe_token_id: token.id, user_id: @user.id
        }
      end
    end

    customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
    assert_not_empty customer.sources.data

    assert_redirected_to edit_user_path(@user)
  end

  test 'should delete payment method' do
    log_in(@user)

    assert_nothing_raised do

      token = Stripe::Token.create(
          :card => {
              :number => @valid_payment_method[:card_number],
              :exp_month => @valid_payment_method[:exp_month],
              :exp_year => @valid_payment_method[:exp_year],
              :cvc => @valid_payment_method[:cvc]
          },
      )

      card = PaymentMethod.create(brand: token.card.brand, exp_month: token.card.exp_month,
                                  exp_year: token.card.exp_year, last4: token.card.last4,
                                  stripe_token_id: token.id, user_id: @user.id)


      assert_difference('PaymentMethod.count', -1) do
        post :destroy, id: card[:id]
      end

      customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
      assert_empty customer.sources.data
    end

    assert_redirected_to edit_user_path(@user)
  end

end
