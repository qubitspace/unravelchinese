class Snippet::SnippetFormCell < Cell::Concept
  include Cell::ManageableForm
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include NestedForm::ViewHelper
  include ActionView::Helpers::JavaScriptHelper

end