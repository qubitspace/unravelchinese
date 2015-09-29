class Section::SectionCell < Cell::Concept
  include Cell::ManageableCell

  property :article
  property :resource
  property :resource_type
  property :sort_order
  property :container
  property :alignment

  private

  def style

    case
    when model.block? then 'section-block'
    when model.inline? then 'section-inline'
    when model.float_left? then 'section-float-left'
    when model.float_right? then 'section-float-right'
    end

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
