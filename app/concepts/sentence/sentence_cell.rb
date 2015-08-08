class Sentence::SentenceCell < Cell::Concept

  include ActionView::Helpers::JavaScriptHelper

  property :id
  property :value
  property :rank
  property :end_paragraph
  property :untokenized

  property :article
  property :words
  property :translations
  property :tokens


  def show
    render :show_sentence
  end

  private

  def current_user
    @options[:current_user]
  end

  def tokenize_sentence_link
    link_to "Tokenize", sentence_manage_path(model)
  end

  def untokenize_sentence_link
    link_to "Untokenize", sentence_untokenize_path(model), method: :put
  end

  class ManageSentenceCell < Sentence::SentenceCell
    def show
      render :manage_sentence
    end
  end

  class InlineSentenceCell < Sentence::SentenceCell
    def show
      render :inline_sentence
    end
  end

  class TokenizeSentenceCell < Sentence::SentenceCell
    def show
      render :tokenize_sentence
    end

    def candidate_tokens
      @options[:candidate_tokens]
    end


    def refresh
      %{
        $('#tokenizer').each(function() {
          $(this).replaceWith('#{j(show)}');
        });
      }
    end


    def manage_article_link
      link_to "Manage Article", article_manage_path(model.article)
    end
  end

end
