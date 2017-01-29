class Payment::DonationPolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    must_be_logged_in(user, record) and user[:admin]
  end

  def create?
    true
  end

  def permitted_attributes
    [:amount, :stripe_token, :notes]
  end

end
