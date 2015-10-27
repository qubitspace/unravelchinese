class SourcePolicy < ApplicationPolicy

  def show?
    @user.admin? or (!@record.disabled && !@record.restricted)
  end
end
