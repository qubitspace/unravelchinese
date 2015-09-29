class IframesController < ApplicationController
  include Concerns::Manageable

  def index
    @iframes = Iframe.order(created_at: :desc).all
  end

  def manage
    @iframe = Iframe.find(params[:iframe_id])
  end

end
