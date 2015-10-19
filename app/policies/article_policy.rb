class ArticlePolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def next_comments?
    true
  end

  def view_raw_content?
    true
  end

  def view_raw_translation?
    true
  end

  # def show?
  #   scope.where(:id => record.id).exists?
  # end

  class Scope < Scope

    def resolve
      if is_admin?
        scope.all
      else
        scope.where(:published => true)
      end
    end
  end

end