class Section::SectionCell < Cell::Concept

  include ActionView::Helpers::JavaScriptHelper

  property :id
  property :article
  property :resource
  property :resource_type
  property :classes
  property :rank

  def show
    render :show_section
  end


  def hide
    %{
      $('#section-#{id}').hide();
    }
  end


  def add_new_section
    %{
      $('#sections').append('#{ j(show) }');
    }
  end

  private

  def current_user
    @options[:current_user]
  end


  class ManageSectionCell < Section::SectionCell
    def show
      render :manage_section
    end

    def delete_section_link
      link_to 'Delete Section', model, method: :delete, data: { confirm: 'Are you sure?' }, remote: true
    end
  end

end
