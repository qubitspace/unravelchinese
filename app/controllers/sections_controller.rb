class SectionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:set_start_time, :set_end_time]
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

  def update
    display_type = params[:section][:display_type]
    section = Section.find(params[:id])
    form = Section::Form.new(section)

    if form.validate(params[:"#{model_type}"])
      form.model.token_offsets = params[:section][:offsets].split(' ')
      form.save
      render js: concept("#{model_type}/#{model_type}_cell/#{display_type}", form.model, current_user: current_user, display_type: display_type).(:refresh)
    else
      render js: concept("#{model_type}/#{model_type}_form_cell", form, current_user: current_user, display_type: display_type).(:show_edit_form)
    end
  end

  # Override to customize the virtual offsets field
  def show_edit_form
    section = Section.find(params[:"section_id"])
    form = Section::Form.new(section)
    form.offsets = section.token_offsets
    render js: concept("section/section_form_cell", form, current_user: current_user, display_type: params[:display_type]).(:show_edit_form)
  end

  def move_up
    section = Section.find(params[:section_id])
    prev_section = section.move_up

    if prev_section.present?
      section_cell = concept("section/section_cell/manage", section, current_user: current_user, prev_section_id: prev_section.id)
      prev_section_cell = concept("section/section_cell/manage", prev_section, current_user: current_user)

      render js: (section_cell.(:refresh) +
                  prev_section_cell.(:refresh)  +
                  section_cell.(:move_up))
    else
      render js: ''
    end
  end

  def move_down
    section = Section.find(params[:section_id])
    next_section = section.move_down

    if next_section.present?
      section_cell = concept("section/section_cell/manage", section, current_user: current_user, next_section_id: next_section.id)
      next_section_cell = concept("section/section_cell/manage", next_section, current_user: current_user)

      render js: section_cell.(:refresh) +
                  next_section_cell.(:refresh)  +
                  section_cell.(:move_down)
    else
      render js: ''
    end
  end

  def set_start_time
    section = Section.find(params[:section_id])
    start_time = params[:start_time]
    section.start_time = start_time
    section.save
    render js: %{
      startTime = $('#section-#{section.id}-start-time');
      startTime.text('#{start_time}');
      startTime.animate({
          backgroundColor: '#FF0000',
          color: '#000'
        }, 3000 );
    }
  end

  def set_end_time
    section = Section.find(params[:section_id])
    end_time = params[:end_time]
    section.end_time = end_time
    section.save
    render js: %{
      endTime = $('#section-#{section.id}-end-time');
      endTime.text('#{end_time}');
      endTime.animate({
          backgroundColor: '#FF0000',
          color: '#000'
        }, 3000 );
    }
  end
end