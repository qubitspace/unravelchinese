class HomePolicy < ApplicationPolicy

  def dashboard
    true
  end

  def welcome
    true
  end

end