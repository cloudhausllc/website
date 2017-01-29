require 'coveralls'
require 'policy_assertions'

Coveralls.wear!

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

StripeMock.webhook_fixture_path = './test/fixtures/stripe_web_hooks/'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end