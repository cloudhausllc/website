require 'test_helper'

class WebHook::StripeEventTest < ActiveSupport::TestCase

  def setup
    @stripe_event = web_hook_stripe_events(:one)
  end

  # validates :livemode, :event_type, :stripe_id, :object, :request, :api_version, :data, presence: true
  test 'stripe_id should be unique' do
    duplicate_event = @stripe_event.dup
    assert_not duplicate_event.valid?
  end

  test 'livemode must be true or false' do
    @stripe_event.livemode = true
    @stripe_event.save
    assert @stripe_event.valid?

    @stripe_event.livemode = false
    @stripe_event.save
    assert @stripe_event.valid?
  end

  test 'event_type is required' do
    ['', ' ', nil].each do |test_var|
      @stripe_event.event_type = test_var
      @stripe_event.save
      assert_not @stripe_event.valid?
    end

    @stripe_event.event_type = 'test123'
    assert @stripe_event.valid?

  end

  test 'stripe_id is required' do
    ['', ' ', nil].each do |test_var|
      @stripe_event.stripe_id = test_var
      @stripe_event.save
      assert_not @stripe_event.valid?
    end

    @stripe_event.stripe_id = 'test123'
    assert @stripe_event.valid?
  end

  test 'object is required' do
    ['', ' ', nil].each do |test_var|
      @stripe_event.object = test_var
      @stripe_event.save
      assert_not @stripe_event.valid?
    end

    @stripe_event.object = 'test123'
    assert @stripe_event.valid?
  end

  test 'request is not required' do
    ['', ' ', nil].each do |test_var|
      @stripe_event.request = test_var
      @stripe_event.save
      assert @stripe_event.valid?
    end
  end

  test 'api_version is not required' do
    ['', ' ', nil].each do |test_var|
      @stripe_event.api_version = test_var
      @stripe_event.save
      assert @stripe_event.valid?
    end

    @stripe_event.api_version = 'test123'
    assert @stripe_event.valid?
  end

  test 'data is required' do
    # assert_raises ActiveRecord::StatementInvalid do
    @stripe_event.data = 'test1234'
    @stripe_event.save
    assert_not @stripe_event.valid?
    # end

    @stripe_event.data = nil
    @stripe_event.save
    assert_not @stripe_event.valid?

    @stripe_event.data = {foo: :bar}
    @stripe_event.save
    assert @stripe_event.valid?
  end

  test 'mark as processing' do
    assert_nil @stripe_event.processing
    @stripe_event.mark_as_processing
    @stripe_event.reload
    assert_not_nil @stripe_event.processing
  end

  test 'mark as processed' do
    assert_nil @stripe_event.processed
    @stripe_event.mark_as_processed
    @stripe_event.reload
    assert_not_nil @stripe_event.processed
  end

  test 'mark as processing class' do
    event = WebHook::StripeEvent.find(@stripe_event.id)
    assert_nil event.processing
    WebHook::StripeEvent.mark_as_processing(event.id)
    @stripe_event.reload
    assert_not_nil @stripe_event.processing
  end

  test 'mark as processed class' do
    event = WebHook::StripeEvent.find(@stripe_event.id)
    assert_nil event.processed
    WebHook::StripeEvent.mark_as_processed(event.id)
    @stripe_event.reload
    assert_not_nil @stripe_event.processed
  end


end
