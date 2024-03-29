class Word::WordAdminMenuCell < Cell::Concept
  inherit_views Word::WordCell

  def show
    render :word_admin_menu
  end

  private

  def current_user
    @options[:current_user]
  end

  def admin?
    current_user.admin?
  end

  def new_word_link
    link_to 'New', new_word_path
  end

  def show_word_link
    validate_model ? link_to('Show', model) : 'Show'
  end

  def edit_word_link
    validate_model ? link_to('Edit', edit_word_path(model)) : 'Edit'
  end

  def manage_word_link
    validate_model ? link_to('Manage', word_manage_path(model)) : 'Manage'
  end

  def validate_model
    model.present? and model.id.present?
  end

end
