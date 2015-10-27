class SourcesController < ApplicationController
  include Concerns::Manageable

  def show
    @source = Source.find params[:id]
    authorize @source
  end

  def index
    authorize Source
    @sources = Source.order(created_at: :desc).all
  end

  def manage
    @source = Source.find(params[:source_id])
    authorize @source
  end

end
