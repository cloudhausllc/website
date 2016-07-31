class Asset::ToolPolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    if must_be_admin(user, record) or (record[:active] and record[:on_premises])
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
        [:active, :on_premises, :value, :name, :user_id, :quantity, :url, :sqft, :model_number, :notes]
      else
        []
      end
    else
      []
    end
  end
end
