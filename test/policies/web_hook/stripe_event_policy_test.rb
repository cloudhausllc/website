require 'test_helper'

class WebHook::StripeEventPolicyTest < PolicyAssertions::Test
  def setup
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @stripe_web_hook = web_hook_stripe_events(:one)

    @available_actions = [:index, :create]
  end

  def test_index
    #Only admin should be able to get index.
    assert_permit @admin_user, WebHook::StripeEvent
    refute_permit @regular_user, WebHook::StripeEvent
    refute_permit nil, WebHook::StripeEvent
  end

  def test_show
    #Only admin should be able to show StripeEvents
    assert_permit @admin_user, @stripe_web_hook
    refute_permit @regular_user, @stripe_web_hook
    refute_permit @regular_user, @stripe_web_hook
  end

  # def test_create
  #   TODO: Not sure how I'm going to do this yet.
  # end
end