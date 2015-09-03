class Image::ImageFormCell < Cell::Concept
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include NestedForm::ViewHelper
  include ActionView::Helpers::JavaScriptHelper

  private

  def display_type
    @options[:display_type]
  end

  def id
    model.id
  end

  # ----
  # Edit
  # ----
  class Edit < Image::ImageFormCell
    def show
      %{
        $('.image.#{display_type}[image-id="#{id}"]').each(function() {
          $(this).replaceWith('#{j(render :image_form)}');
        });
      }
    end

    def cancel_link
      link_to "Cancel", image_cancel_edit_form_path(model, display_type), remote: true, method: :put
    end
  end

  # ----
  # New
  # ----
  class New < Image::ImageFormCell

    def show
      %{
        $('.image[image-id="new"]').remove();
        $('.images').prepend('#{j(render :image_form)}');
      }
    end
    private

    def id
      'new'
    end

  end
end