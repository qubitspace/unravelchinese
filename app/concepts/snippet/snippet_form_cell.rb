class Snippet::SnippetFormCell < Cell::Concept
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include NestedForm::ViewHelper
  include ActionView::Helpers::JavaScriptHelper

  property :id

  def show
    render :snippet_form
  end

  def refresh_form
    %{
      $('#create_snippet').html('#{j(show)}');
    }
  end

end