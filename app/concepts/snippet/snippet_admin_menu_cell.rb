class Snippet::SnippetAdminMenuCell < Cell::Concept
  inherit_views Snippet::SnippetCell

  def show
    render :snippet_admin_menu
  end

  private

  def current_user
    @options[:current_user]
  end

  def admin?
    current_user.admin?
  end


  def snippets_link
    link_to 'Index', :snippets
  end

  def new_snippet_link
    link_to 'New', new_snippet_path
  end

  def show_snippet_link
    validate_model ? link_to('Show', model) : 'Show'
  end

  def edit_snippet_link
    validate_model ? link_to('Edit', edit_snippet_path(model)) : 'Edit'
  end

  def validate_model
    model.present? and model.id.present?
  end

end
