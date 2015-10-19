class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)

    #raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

  def is_admin?
    user && user.admin?
  end

  # The default permissions if a more specific check hasn't been defined
  def method_missing(method, *args, &block)
    is_admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end

    def is_admin?
      user && user.admin?
    end
  end


  private


end

