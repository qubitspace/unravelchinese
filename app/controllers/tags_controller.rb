class TagsController < ApplicationController
  def index
    #@tags = Tag.includes(:words).all
    #@word_counts = Tag.includes(:words).count(group: 'tag.id')
    @tags = Tag.with_word_count limit: 1000
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
