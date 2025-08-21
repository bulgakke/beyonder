class PostPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    @record.author == @user
  end

  def edit?
    update?
  end

  def destroy?
    @record.author == @user || @record.resource == @user
  end
end
