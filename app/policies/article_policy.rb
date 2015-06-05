class ArticlePolicy < ApplicationPolicy
  attr_reader :user, :article

  def initialize(user, article)
    @user = user
    @article = article
  end

  def index?
    true #@user.admin?
  end

  def show?
    scope.where(:id => article.id).exists?
  end

  def create?
    admin?
  end

  def new?
    admin?
  end


  def edit?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
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

  private

  def admin?
    user.admin?
  end

end