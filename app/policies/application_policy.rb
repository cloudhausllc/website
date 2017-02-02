class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    must_be_admin(@user, @record)
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    must_be_admin(@user, @record)
  end

  def new?
    create?
  end

  def update?
    must_be_admin(@user, @record)
  end

  def edit?
    update?
  end

  def destroy?
    must_be_admin(@user, @record)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end

    def user_is_admin(user, record)
      if not user.nil? and user[:admin]
        return true
      else
        return false
      end
    end
  end

  private

  def must_be_admin(user, record)
    if user and user[:admin]
      return true
    else
      return false
    end
  end

  def admin_or_self?(user, record)
    user[:admin] or record == user
  end

  def must_be_logged_in(user, record)
    if user and user[:active]
      return true
    else
      return false
    end
  end

end
