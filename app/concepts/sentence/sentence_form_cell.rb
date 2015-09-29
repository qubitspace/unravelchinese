class Sentence::SentenceFormCell < Cell::Concept
  include Cell::ManageableForm

  #property :translations

  def add_sentence
    render :add_sentence_form
  end

  def article
    options[:article]
  end

  def refresh_form
    %{
      $('.add_#{model_type}').html('#{j(add_sentence)}');
    }
  end

end