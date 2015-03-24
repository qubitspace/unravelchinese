class ArticlePolicy < ApplicationPolicy
  attr_reader :user, :article

  def initialize(user, article)
    @user = user
    @article = article
  end

  def index?
    true
  end

  def show?
    scope.where(:id => article.id).exists?
  end

  def create?
    user.admin?
  end

  def new?
    create?
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
    Pundit.policy_scope!(user, article.class)
  end

  class Scope < Scope
    attr_reader :user, :scope


    def resolve
      if user.admin?
        scope.all
      else
        scope.where(:published => true)
      end
    end
  end


end