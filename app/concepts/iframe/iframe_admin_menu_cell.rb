class Iframe::IframeAdminMenuCell < Cell::Concept
  inherit_views Iframe::IframeCell

  def show
    render :iframe_admin_menu
  end

  private

  def current_user
    @options[:current_user]
  end

  def admin?
    current_user.admin?
  end


  def iframes_link
    link_to 'Index', :iframes
  end

  def new_iframe_link
    link_to 'New', new_iframe_path
  end

  def show_iframe_link
    validate_model ? link_to('Show', model) : 'Show'
  end

  def edit_iframe_link
    validate_model ? link_to('Edit', edit_iframe_path(model)) : 'Edit'
  end

  def validate_model
    model.present? and model.id.present?
  end

end
