class MembershipLevelPolicy < ApplicationPolicy

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

  def permitted_attributes_for_create
    [:monthly_payment]
  end

  def edit?
    update?
  end

  def update?
    must_be_logged_in(user, record) and user[:admin]
  end


  def permitted_attributes_for_update
    [:monthly_payment]
  end

  def destroy?
    must_be_logged_in(user, record) and user[:admin]
  end

  def create?
    must_be_logged_in(user, record) and user[:admin]
  end

  def permitted_attributes
    if not user.nil?
      if user[:admin]
        [:name, :monthly_payment]
      else
        []
      end
    else
      []
    end
  end

end
