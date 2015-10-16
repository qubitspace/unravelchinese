class IframesController < ApplicationController
  include Concerns::Manageable

  def index
    authorize Iframe
    @iframes = Iframe.order(created_at: :desc).all
  end

  def manage
    @iframe = Iframe.find(params[:iframe_id])
    authorize @iframe
  end

end
