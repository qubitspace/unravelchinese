class Section::SectionFormCell < Cell::Concept
  include Cell::ManageableForm

  def add_section
    render :add_section_form
  end

  def refresh_new_section_form
    %{
      $('.new_section').html('#{j(add_section)}');
    }
  end
end