class UserPolicy < ApplicationPolicy

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user
    @user = user
    @record = record
  end

  def index?
    user[:admin]
  end

  def show?
    admin_or_self?(user, record)
  end

  def permitted_attributes_for_create
    [:first_name, :last_name, :email, :password, :password_confirmation]
  end

  def edit?
    admin_or_self?(user, record)
  end

  def update?
    admin_or_self?(user, record)
  end


  def permitted_attributes_for_update
    if user[:admin]
      [:first_name, :last_name, :password, :active, :admin, :email]
    else
      [:first_name, :last_name, :password, :email]
    end
  end

  def destroy?
    user[:admin] and record != user
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

  private

  def admin_or_self?(user, record)
    user[:admin] or record == user
  end

end
