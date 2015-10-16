class ApplicationController < ActionController::Base
  include Monban::ControllerHelpers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  #protect_from_forgery with: :exception
  #before_action :require_login, except: [:welcome]

  #after_action :verify_policy_scoped
  after_action :verify_authorized

  #include Trailblazer::Operation::Controller
  #require 'trailblazer/operation/controller/active_record'
  #include Trailblazer::Operation::Controller::ActiveRecord # named instance variables.

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end


# Pundit docs
# https://github.com/elabs/pundit