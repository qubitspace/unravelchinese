###TODO
# Can probably share views better.
# Preview and search result can share a view
  # Instead of using link and highlight methods, just call Simplified/Traditional/Pinyin and each class knows what to do.

class Word::WordCell < Cell::Concept

  include ActionView::Helpers::JavaScriptHelper

  property :id
  property :simplified
  property :traditional
  property :pinyin
  property :strokes
  property :radical_number
  property :word_frequency
  property :character_frequency
  property :hsk_word_level
  property :hsk_character_level
  property :definitions
  property :tags

  def show
    render :word_show
  end

  def refresh
    %{
      $('.word.#{type}[word-id="#{id}"]').each(function() {
        $(this).replaceWith('#{j(show)}');
      });
    }
  end

  private

  def type
    'show'
  end

  def current_user
    @options[:current_user]
  end

  def status
    if model.category == 'punctuation'
      status = 'known'
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
    return links if status == 'punctuation'

    links << update_status_link(:known) if status != 'known'
    links << update_status_link(:unknown) if status != 'unknown'
    links << update_status_link(:learning) if status != 'learning'

    return links
  end


  def update_status_link status
    link_to "Mark as #{status.capitalize}", update_status_path(status), remote: true, method: :put
  end

  def update_status_path status
    word_update_status_path word_id: id, status: status
  end

  # add a helper method (enumeration?)
  # which will lookup through all the status this is not and give the links
  # unless it's a punctionation of course...
  # either collect the links in a list, or yield some values to generate the link... like the text and the path...


  class WordManageCell < Word::WordCell

    def show
      render :word_manage
    end

    def type
      'manage'
    end

  end


  class WordPreviewCell < Word::WordCell

    def show
      render :word_preview
    end

    def type
      'preview'
    end

  end

  class WordSearchResultCell < Word::WordCell

    def show
      render :word_search_result
    end

    def type
      'search_result'
    end

    def highlight value
      Word.highlight(value, query)
    end

    def query
      @options[:query]
    end

    def update_status_path status
      word_update_status_path word_id: id, status: status, query: query
    end

  end

end
