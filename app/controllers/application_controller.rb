class ApplicationController < ActionController::Base
  include Monban::ControllerHelpers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception
  before_action :require_login, except: [:welcome]

  #include Trailblazer::Operation::Controller
  #require 'trailblazer/operation/controller/active_record'
  #include Trailblazer::Operation::Controller::ActiveRecord # named instance variables.
end
