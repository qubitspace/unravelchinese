class WordPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def update_status?
    true
  end

end