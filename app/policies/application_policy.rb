class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false unless user[:admin]
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false unless user[:admin]
  end

  def new?
    create?
  end

  def update?
    false unless user[:admin]
  end

  def edit?
    update?
  end

  def destroy?
    false unless user[:admin]
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
  end

  private

  def admin_or_self?(user, record)
    user[:admin] or record == user
  end

  def must_be_logged_in(user, record)
    if user
      return true
    else
      return false
    end
  end

end
