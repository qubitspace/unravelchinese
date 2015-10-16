class TagsController < ApplicationController
  include Concerns::Manageable

  def index
    authorize Tag
    @tags = Tag.with_taggable_count params
  end

  def show
    @tag = Tag.find(params[:id])
    authorize @tag
  end

  def manage
    @tag = Tag.find(params[:id])
    authorize @tag
  end

end
