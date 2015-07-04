###TODO
# Can probably share views better.
# Preview and search result can share a view
  # Instead of using link and highlight methods, just call Simplified/Traditional/Pinyin and each class knows what to do.

class Definition::DefinitionCell < Cell::Concept

  include Partial

  property :id
  property :value
  property :rank

  property :word

  def show
    render :definition_show
  end

  private

  def current_user
    @options[:current_user]
  end

  def error_messages
    @options[:errors].present? ? @options[:errors].messages : []
  end

  class DefinitionManageCell < Definition::DefinitionCell

    def show
      render :definition_manage
    end

    private

    def show_edit_form_link
      link_to 'Edit', definition_show_edit_form_path(model), remote: true
    end

    def delete_link
      link_to 'Delete', model, method: :delete, data: { confirm: 'Are you sure?' }
    end
  end
end