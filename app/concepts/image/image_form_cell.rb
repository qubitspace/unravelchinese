class Image::ImageFormCell < Cell::Concept
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include NestedForm::ViewHelper
  include ActionView::Helpers::JavaScriptHelper

  property :id

  def add_image
    render :add_image_form
  end

  def refresh_form
    %{
      $('#create_image').html('#{j(add_image)}');
    }
  end

end