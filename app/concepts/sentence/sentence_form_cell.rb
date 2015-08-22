class Sentence::SentenceFormCell < Cell::Concept
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include NestedForm::ViewHelper
  include ActionView::Helpers::JavaScriptHelper

  property :id
  property :translations

  def show
    render :sentence_form
  end

  def test_show
    render :test_sentence_form
  end

  def refresh_form
    %{
      $('#create_sentence').html('#{j(show)}');
    }
  end

end