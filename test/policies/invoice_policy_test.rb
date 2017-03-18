require 'test_helper'

class InvoicePolicyTest < PolicyAssertions::Test
  def setup
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @admin_invoice = invoices(:admin_invoice)
    @regular_user_invoice = invoices(:regular_user_invoice)

    @available_actions = [:show]
  end

  def test_index
    #Nobody should be able to get index.
    refute_permit @admin_user, Invoice
    refute_permit @regular_user, Invoice
    refute_permit nil, Invoice
  end

  def test_show
    #Admin can show any invoices
    assert_permit @admin_user, @admin_invoice
    assert_permit @admin_user, @regular_user_invoice

    #Regular user can only show own invoices
    refute_permit @regular_user, @admin_invoice
    @regular_user_invoice.update!(customer_id: @regular_user.stripe_customer_id)
    assert_permit @regular_user, @regular_user_invoice

    #Anon can't show any invoices
    refute_permit nil, @admin_invoice
    refute_permit nil, @regular_user_invoice
  end

  def test_edit_and_update
    #Nobody should be able to get edit and update.
    refute_permit @admin_user, Invoice
    refute_permit @regular_user, Invoice
    refute_permit nil, Invoice
  end

  def test_destroy
    #Nobody should be able to destroy.
    refute_permit @admin_user, Invoice
    refute_permit @regular_user, Invoice
    refute_permit nil, Invoice
  end

  def test_create_and_new
    #Nobody should be able to get create and new.
    refute_permit @admin_user, Invoice
    refute_permit @regular_user, Invoice
    refute_permit nil, Invoice
  end

  def test_strong_parameters
    invoice_attributes = @admin_invoice.attributes
    admin_params = []
    regular_user_params = []
    anonymous_params = []

    assert_strong_parameters(@admin_user, Invoice, invoice_attributes, admin_params)
    assert_strong_parameters(@regular_user, Invoice, invoice_attributes, regular_user_params)
    assert_strong_parameters(nil, Invoice, invoice_attributes, anonymous_params)
  end

end