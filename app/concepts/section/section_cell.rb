class Section::SectionCell < Cell::Concept
  include Cell::ManageableCell

  property :article
  property :resource
  property :resource_type
  property :sort_order
  property :container
  property :alignment
  property :end_paragraph
  property :start_time
  property :end_time
  property :token_offsets
  property :is_clone

  def move_up
    %{
      $('.section.manage[section-id="#{id}"]').insertBefore('.section.manage[section-id="#{prev_section_id}"]');
    }
  end

  def move_down
    %{
      $('.section.manage[section-id="#{id}"]').insertAfter('.section.manage[section-id="#{next_section_id}"]');
    }
  end

  private

  def prev_section_id
    @options[:prev_section_id]
  end

  def next_section_id
    @options[:next_section_id]
  end

  def style
    style = case
                when model.block? then 'section-block'
                when model.inline? then 'section-inline'
                when model.float_left? then 'section-float-left'
                when model.float_right? then 'section-float-right'
              end
    style += ' end-paragraph' if end_paragraph
    style
  end

  def move_up_link
    link_to "Move Up", section_move_up_path(model), method: :put, remote: true
  end

  def move_down_link
    link_to "Move Down", section_move_down_path(model), method: :put, remote: true
  end


  # Manage
  class Manage < Section::SectionCell
  end

  # List
  class List < Section::SectionCell
  end

  # Inline
  class Inline < Section::SectionCell
  end

end
