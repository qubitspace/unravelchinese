class Iframe::IframeFormCell < Cell::Concept
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
  class Edit < Iframe::IframeFormCell
    def show
      %{
        $('.iframe.#{display_type}[iframe-id="#{id}"]').each(function() {
          $(this).replaceWith('#{j(render :iframe_form)}');
        });
      }
    end

    def cancel_link
      link_to "Cancel", iframe_cancel_edit_form_path(model, display_type), remote: true, method: :put
    end
  end

  # ----
  # New
  # ----
  class New < Iframe::IframeFormCell

    def show
      %{
        $('.iframe[iframe-id="new"]').remove();
        $('.iframes').prepend('#{j(render :iframe_form)}');
      }
    end
    private

    def id
      'new'
    end

    def cancel_link
      #link_to "Cancel", iframe_cancel_new_form_path(model, display_type), remote: true, method: :put
    end
  end
end