class Iframe::IframeCell < Cell::Concept
  include ActionView::Helpers::JavaScriptHelper

  property :id
  property :url
  property :title
  property :description
  property :created_at

  include Cell::CreatedAt

  def remove_iframe
    %{
      $('.iframe[iframe-id="#{id}"]').each(function() {
        $(this).remove();
      });
    }
  end

  def add_iframe
    %{
      $('.iframe[iframe-id="new"]').remove();
      $('.iframes').prepend('#{j(show)}');
    }
  end

  def refresh_iframe
    %{
      $('.iframe.#{display_type}[iframe-id="#{id}"]').each(function() {
        $(this).replaceWith('#{j(show)}');
      });
    }
  end

  private

  def edit_link
    link_to "Edit", iframe_show_edit_form_path(model, display_type), remote: true, method: :put
  end

  def delete_link
    link_to "Delete", iframe_path(model, display_type: display_type), remote: true, method: :delete, :data => { :confirm => 'Permanently delete this Iframe?' }
  end

  def current_user
    @options[:current_user]
  end

  # ----
  # Manage
  # ----
  class Manage < Iframe::IframeCell

    def show
      render :manage_iframe
    end

    private

    def display_type
      'manage'
    end
  end

  # ----
  # List
  # ----
  class List < Iframe::IframeCell

    def show
      render :list_iframe
    end

    private

    def display_type
      'list'
    end
  end

  # ----
  # Inline
  # ----
  class Inline < Iframe::IframeCell

    def show
      render :inline_iframe
    end

    private

    def display_type
      'inline'
    end
  end

end

