class TagsController < ApplicationController
  def index
    #model this off off comments, add a link to load more pages and search

    # Just pass through params since it will parse them out for now
    @tags = Tag.with_taggable_count params
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    redirect_to tags_path
  end

end
