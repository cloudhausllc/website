class NewsArticlePolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    if must_be_admin(user, record) or record[:published]
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
        [:id, :user_id, :subject, :body, :published]
      else
        []
      end
    else
      []
    end
  end

  # class Scope < Scope
  #   def resolve
  #     if @user and @user.admin
  #       scope.all
  #     else
  #       scope.where(published: true)
  #     end
  #   end
  # end

end
