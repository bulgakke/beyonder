class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def me?
    true
  end

  def create?
    true
  end

  def update?
    @user == @record
  end

  def edit?
    update?
  end
end
