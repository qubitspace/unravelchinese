class Image::ImageAdminMenuCell < Cell::Concept
  inherit_views Image::ImageCell

  def show
    render :image_admin_menu
  end

  private

  def current_user
    @options[:current_user]
  end

  def admin?
    current_user.admin?
  end


  def images_link
    link_to 'Index', :images
  end

  def new_image_link
    link_to 'New', new_image_path
  end

  def show_image_link
    # This is strangely not working with a helper.
    validate_model ? link_to('Show', "/images/#{model.id}") : 'Show'
  end

  def edit_image_link
    validate_model ? link_to('Edit', edit_image_path(model)) : 'Edit'
  end

  def validate_model
    model.present? and model.id.present?
  end

end
