class SourcePolicy < ApplicationPolicy
  attr_reader :user, :source

  def initialize(user, source)
    @user = user
    @source = source
  end

  def index?
    true
  end

  def show?
    scope.where(:id => source.id).exists?
  end

  def create?
    user.admin?
  end

  def new?
    user.admin?
  end

  def update?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def scope
    Pundit.policy_scope!(user, source.class)
  end

  class Scope < Scope
    attr_reader :user, :scope

    def resolve
      scope.all
    end
  end

end