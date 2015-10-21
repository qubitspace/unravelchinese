class HomeController < ApplicationController
  skip_after_action :verify_authorized, only: [:dashboard, :welcome]

  def dashboard
  end

  def welcome
  end
end
