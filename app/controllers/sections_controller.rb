class SectionsController < ApplicationController
  include Concerns::Manageable

  def manage
    @section = Section.find(params[:section_id])
  end

  def create
    article = Article.find params[:section][:article_id]

    display_type = params[:section][:display_type]
    resource_type = params[:section][:resource_type]

    if resource_type == "Sentence"
      params[:section].delete :snippet_attributes
    elsif resource_type == "Snippet"
      params[:section].delete :sentence_attributes
    elsif resource_type == "Photo"
      params[:section].delete :sentence_attributes
      params[:section].delete :snippet_attributes
      params[:section][:resource_id] = params[:section][:photo_id]
    elsif resource_type == "Iframe"
      params[:section].delete :sentence_attributes
      params[:section].delete :snippet_attributes
      params[:section][:resource_id] = params[:section][:iframe_id]
    end

    form = Section::Form.new(Section.new)

    if form.validate(params[:section])
      form.model.set_sort_order article
      form.save
      render js: concept("section/section_cell/#{display_type}", form.model, current_user: current_user).(:append)
    else
      render js: concept("section/section_form_cell", form, current_user: current_user, display_type: display_type).(:refresh_new_section_form)
    end
  end

  def move_up
  end

  def move_down
  end

end