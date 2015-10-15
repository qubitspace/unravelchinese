class HomeController < ApplicationController
  skip_after_action :verify_authorized, only: [:dashboard, :welcome]
  skip_after_action :verify_policy_scoped, only: [:dashboard, :welcome]

  def dashboard
  end

  def welcome
  end
end
