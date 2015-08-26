class Article::ArticleFormCell < Cell::Concept
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include NestedForm::ViewHelper
  include ActionView::Helpers::JavaScriptHelper

  property :id

  def show
    render :article_form
  end

end