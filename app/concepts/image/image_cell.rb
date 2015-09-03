class Image::ImageCell < Cell::Concept
  include ActionView::Helpers::JavaScriptHelper

  property :id
  property :file
  property :title
  property :created_at

  property :source_id
  property :source do
    property :id
    property :link
    property :name
  end

  include Cell::CreatedAt

  def remove_image
    %{
      $('.image[image-id="#{id}"]').each(function() {
        $(this).remove();
      });
    }
  end

  def add_image
    %{
      $('.image[image-id="new"]').remove();
      $('.images').prepend('#{j(show)}');
    }
  end

  def refresh_image
    %{
      $('.image.#{display_type}[image-id="#{id}"]').each(function() {
        $(this).replaceWith('#{j(show)}');
      });
    }
  end

  private

  def edit_link
    link_to "Edit", image_show_edit_form_path(model, display_type), remote: true, method: :put
  end

  def delete_link
    link_to "Delete", image_path(model, display_type: display_type), remote: true, method: :delete, :data => { :confirm => 'Permanently delete this Image?' }
  end

  def current_user
    @options[:current_user]
  end

  # ----
  # Manage
  # ----
  class Manage < Image::ImageCell

    def show
      render :manage_image
    end

    private

    def display_type
      'manage'
    end
  end

  # ----
  # List
  # ----
  class List < Image::ImageCell

    def show
      render :list_image
    end

    private

    def display_type
      'list'
    end
  end

  # ----
  # Inline
  # ----
  class Inline < Image::ImageCell

    def show
      render :inline_image
    end

    private

    def display_type
      'inline'
    end
  end

end

