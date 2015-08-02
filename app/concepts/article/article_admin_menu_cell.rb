class Article::ArticleAdminMenuCell < Cell::Concept
  inherit_views Article::ArticleCell

  def self._local_prefixes
    ["test"]
  end

  def show
    render :article_admin_menu
  end

  private

  def current_user
    @options[:current_user]
  end

  def admin?
    current_user.admin?
  end

  def new_article_link
    link_to 'New', new_article_path
  end

  def show_article_link
    validate_model ? link_to('Show', model) : 'Show'
  end

  def edit_article_link
    validate_model ? link_to('Edit', edit_article_path(model)) : 'Edit'
  end

  def manage_article_link
    validate_model ? link_to('Manage', article_manage_path(model)) : 'Manage'
  end

  def validate_model
    model.present? and model.id.present?
  end


end
