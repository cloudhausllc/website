class IndexImagePolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    must_be_admin(user, record)
  end

  def show?
    if record[:active] or must_be_admin(user, record)
      true
    else
      false
    end
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
    create?
  end

  def create?
    must_be_admin(user, record)
  end

  def permitted_attributes
    if not user.nil?
      if user[:admin]
        [:id, :active, :user_id, :image, :caption, :url]
      else
        []
      end
    else
      []
    end
  end
end
