class Word::WordCell < Cell::Concept
  include Cell::ManageableCell

  property :simplified
  property :traditional
  property :pinyin
  property :category
  property :strokes
  property :radical_number
  property :word_frequency
  property :character_frequency
  property :hsk_word_level
  property :hsk_character_level

  property :definitions
  property :tags
  property :taggings

  def refresh
    %{
      $('.word.#{display_type}[word-id="#{id}"]').each(function() {
        $(this).replaceWith('#{j(show)}');
      });

      $('.word[word-id=#{id}]').each(function () {
        addWordTooltip($(this));
        addCloseWordTooltipActions(); // TODO: This should only be applied to the new word id.
        if ('#{status}' == 'learning')
        {
          addLearningMouseover($(this));
        }
        $(this).addClass("flash");
      });
    }
  end

  private

  def status


    if ['alphanumeric','punctuation'].include? model.category
      status = 'known'
    elsif !current_user.present?
      return 'unknown'
    else
      status = current_user.word_statuses.has_key?(id) ? current_user.word_statuses[id].status : 'unknown'
    end
    return status
  end

  def link display
    link_to(display, model).html_safe
  end

  def status_links
    links = []
    return links if status == 'punctuation' || !current_user.present?

    links << update_status_link(:known) if status != 'known'
    links << update_status_link(:unknown) if status != 'unknown'
    links << update_status_link(:learning) if status != 'learning'
    links << update_status_link(:watching) if status != 'watching'

    return links
  end

  def update_status_link status
    link_to "Mark as #{status.capitalize}", update_status_path(status), remote: true, method: :put
  end

  def update_status_path status
    word_update_status_path word_id: id, status: status
  end

  # Show
  class Show < Word::WordCell
  end

  # Manage
  class Manage < Word::WordCell
  end

  # Inline
  class Inline < Word::WordCell
  end

  # List
  class List < Word::WordCell

    private

    def simplified
      link(model.simplified)
    end

    def traditional
      link(model.traditional)
    end

    def pinyin
      link(model.pinyin)
    end

    def update_status_path status
      word_update_status_path word_id: id, status: status
    end

  end

  # List > Search
  class Search < Word::WordCell::List

    # Default will just show based on the class, so override it to use list.
    def show
      render :list_word
    end

    private

    def query
      @options[:query]
    end

    def simplified
      highlight model.simplified, true
    end

    def traditional
      highlight model.traditional
    end

    def pinyin
      highlight model.pinyin, @options[:match_accents]
    end

    def highlight value, match_accents = false
      Word.highlight(value, query, match_accents)
    end

    def update_status_path status
      word_update_status_path word_id: id, status: status, query: query
    end

  end


end
