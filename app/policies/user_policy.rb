class UserPolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    must_be_logged_in(user, record) and user[:admin]
  end

  def show?
    must_be_logged_in(user, record) and admin_or_self?(user, record)
  end

  def permitted_attributes_for_create
    [:first_name, :last_name, :email, :password, :password_confirmation]
  end

  def edit?
    must_be_logged_in(user, record) and admin_or_self?(user, record)
  end

  def update?
    must_be_logged_in(user, record) and admin_or_self?(user, record)
  end


  def permitted_attributes_for_update
    if user[:admin]
      [:first_name, :last_name, :password, :active, :admin, :email, :plan_id]
    else
      [:first_name, :last_name, :password, :email, :plan_id]
    end
  end

  def destroy?
    must_be_logged_in(user, record) and user[:admin] and record != user
  end

  def create?
    true if user.nil? or user[:admin]
  end

  def permitted_attributes
    if not user.nil?
      if user[:admin]
        [:first_name, :last_name, :password, :active, :admin, :email]
      else
        [:first_name, :last_name, :password, :email]
      end
    else
      [:first_name, :last_name, :password, :email]
    end
  end

end
