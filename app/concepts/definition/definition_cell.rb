###TODO
# Can probably share views better.
# Preview and search result can share a view
  # Instead of using link and highlight methods, just call Simplified/Traditional/Pinyin and each class knows what to do.

class Definition::DefinitionCell < Cell::Concept


  #include Partial

  property :id
  property :value
  property :rank

  property :word

  def show
    render :show
  end

  private

  def current_user
    @options[:current_user]
  end

  class ManageDefinitionCell < Definition::DefinitionCell

    def show
      render :manage_definition
    end

    private

    def edit_definition_form_link
      link_to 'Edit', word_show_edit_definition_form_path(word, model), remote: true
    end

    def delete_definition_link
      link_to 'Delete', word_delete_definition_path(word, model), method: :delete, data: { confirm: 'Are you sure?' }, remote: true
    end
  end

end