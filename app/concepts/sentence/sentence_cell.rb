class Sentence::SentenceCell < Cell::Concept
  include Cell::ManageableCell

  property :value
  property :sort_order
  property :untokenized

  property :section
  property :words
  property :translations
  property :tokens
  property :translatable
  property :auto_translate
  property :has_traditional_characters

  private

  def article
    section.article
  end

  # It's named like this to avoid confusion with the non ajax link to go to the manage
  def show_manage_cell_link
    link_to "Manage", sentence_show_manage_cell_path(model), remote: true
  end

  def retranslate_link
    link_to "Retranslate", sentence_retranslate_path(model), remote: true, method: :put
  end

  def tokenize_link
    link_to "Tokenize", sentence_show_tokenize_cell_path(model), remote: true
  end

  def untokenize_link
    link_to "Untokenize", sentence_untokenize_path(model), method: :put, remote: true, confirm: 'Are you sure?'
  end

  def remove_last_token_link
    link_to "Remove Last Token", sentence_remove_last_token_path(model), remote: true, method: :put, confirm: 'Are you sure?'
  end

  # Manage
  class Manage < Sentence::SentenceCell
    def show_manage_cell
      %{
        $('.sentence.tokenize[sentence-id="#{id}"]').each(function() {
          $(this).replaceWith('#{j(show)}');
        });
      }
    end
  end

  # Show
  class Show < Sentence::SentenceCell
  end

  # List
  class List < Sentence::SentenceCell
  end

  # Inline
  class Inline < Sentence::SentenceCell
  end

  # Manage
  class Tokenize < Sentence::SentenceCell

    def show
      render :tokenize_sentence
    end

    def candidate_tokens
      @options[:candidate_tokens] || []
    end

    def show_tokenize_cell
      %{
        $('.sentence.manage[sentence-id="#{id}"]').each(function() {
          $(this).replaceWith('#{j(show)}');
        });
      }
    end

    def refresh
      %{
        $('.sentence.tokenize[sentence-id="#{id}"]').each(function() {
          $(this).replaceWith('#{j(show)}');
        });
      }
    end

  end
end
