class WordPolicy < ApplicationPolicy

  def show?
    true
  end

  def update_status?
    true
  end

end