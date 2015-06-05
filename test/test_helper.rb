ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Rails.backtrace_cleaner.remove_silencers!


MiniTest::Spec.class_eval do
  #include Monban::Test::Helpers, type: :feature
  after :each do
    # DatabaseCleaner.clean
    Article.delete_all
    Comment.delete_all
    User.delete_all
    Monban.test_reset!
    Warden.test_reset!
  end
end

class ActionController::TestCase
  include Monban::Test::Helpers
  include Monban::Test::ControllerHelpers
end