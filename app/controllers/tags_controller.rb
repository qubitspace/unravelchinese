class TagsController < ApplicationController
  include Concerns::Manageable

  def index
    @tags = Tag.with_taggable_count params
  end

  def show
    @tag = Tag.find(params[:id])
  end

end
