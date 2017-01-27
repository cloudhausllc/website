class WebHook::StripeEventPolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    must_be_logged_in(user, record) and user[:admin]
  end

  def show?
    must_be_logged_in(user, record) and user[:admin]
  end
end
