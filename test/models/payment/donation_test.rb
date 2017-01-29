require 'test_helper'

class Payment::DonationTest < ActiveSupport::TestCase

  setup do
    @donation = payments(:small_donation)
  end

  test 'pretty type should be donation' do
    assert_equal @donation.pretty_type, 'Donation'
  end
end
