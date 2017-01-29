require 'test_helper'

class Payment::DonationPolicyTest < PolicyAssertions::Test
  def setup
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @donation = payments(:small_donation)

    @available_actions = [:index, :new, :create]
  end

  def test_index
    #Only admin should be able to list donations.
    assert_permit @admin_user, Payment::Donation
    refute_permit @regular_user, Payment::Donation
    refute_permit nil, Payment::Donation
  end

  def test_create_and_new
    #Anyone should be able to create a new donation.
    assert_permit @admin_user, Payment::Donation
    assert_permit @regular_user, Payment::Donation
    assert_permit nil, Payment::Donation
  end

  def test_strong_parameters
    donation_attributes = @donation.attributes
    all_params = [:amount, :stripe_token, :notes]

    assert_strong_parameters(@admin_user, Payment::Donation, donation_attributes, all_params)
    assert_strong_parameters(@regular_user, Payment::Donation, donation_attributes, all_params)
    assert_strong_parameters(nil, Payment::Donation, donation_attributes, all_params)
  end

end