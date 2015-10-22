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
  after_filter :store_location

  #include Trailblazer::Operation::Controller
  #require 'trailblazer/operation/controller/active_record'
  #include Trailblazer::Operation::Controller::ActiveRecord # named instance variables.

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end


  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/session/new" and
        request.path != "/session" and
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def session_redirect_path
    session[:previous_url] || root_path
  end

end


# Pundit docs
# https://github.com/elabs/pundit