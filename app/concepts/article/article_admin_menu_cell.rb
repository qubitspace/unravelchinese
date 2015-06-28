class Article::ArticleAdminMenuCell < Cell::Concept

  def show
    render :admin_menu
  end

  private

  def current_user
    @options[:current_user]
  end

  def admin?
    current_user.admin?
  end

  def show_link
    link_to 'Show', model
  end

  def edit_link
    link_to 'Edit', edit_article_path(model)
  end

  def manage_link
    link_to 'Manage', article_manage_path(model)
  end

end
