class MembershipLevelPolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    must_be_admin(user, record)
  end

  def show?
    must_be_admin(user, record)
  end

  def edit?
    update?
  end

  def update?
    must_be_admin(user, record)
  end

  def destroy?
    must_be_admin(user, record)
  end

  def new?
    must_be_admin(user, record)
  end

  def create?
    must_be_admin(user, record)
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
