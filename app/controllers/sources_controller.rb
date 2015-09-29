class SourcesController < ApplicationController
  include Concerns::Manageable

  def index
    @sources = Source.order(created_at: :desc).all
  end

  def manage
    @source = Source.find(params[:source_id])
  end

end
