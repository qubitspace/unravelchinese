class TaggablesController < ApplicationController

  def untag
    @tagging = Tagging.find params[:tagging_id]
    @tagging.destroy

    respond_to do |format|
      format.js { render :action => "../#{params[:taggable_type].downcase.pluralize}/remove_tag"}
    end
  end

  def tag
    @taggable = Object::const_get(params[:taggable_type]).find(params[:taggable_id])
    @tagging = @taggable.tag params[:tag][:name]
    @new_form = Tag::Form.new(Tag.new)

    respond_to do |format|
      format.js { render :action => "../#{params[:taggable_type].downcase.pluralize}/show_new_tag"}
    end
  end

end

