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

  def show
    render :show_word
  end

  def show_header
    render :show_header
  end

  def refresh
    %{
      $('.word.#{type}[word-id="#{id}"]').each(function() {
        $(this).replaceWith('#{j(show)}');
      });
      function addWordTooltip(word) {
        word.qtip({
            content: word.find('.tooltip'),
            show: {
                event: 'click',
                solo: true,
                effect: function() {
                    $(this).fadeTo(200, 1);
                }
            },
            hide: {
                event: 'unfocus',
                fixed: true
            },
            style: {
                classes: "qtip-bootstrap"
            },
            position: {
                my: 'bottom center',
                at: 'top center',
                viewport: $(window),
                adjust: {
                    method: 'shift flip'
                }
            }
        });

      }

      function addWordTooltips()
      {
          $('.word').each(function () {
              addWordTooltip($(this));
          });
      }

      function addLearningMouseover(word) {
          word.mouseover(function() {
              $(this).find(".bottom").css('color', '#666');
          });
          word.mouseout(function() {
              $(this).find(".bottom").css('color', '#FFFFFF');
          });
      }

      function addCloseWordTooltipActions() {
          $('.close_tooltip').click(function() {
              $(this).closest('div.qtip').hide();
          });
      }

      var ready;
      ready = function() {
        $('.word[word-id=#{id}]').each(function () {
          addWordTooltip($(this));
          addCloseWordTooltipActions(); // TODO: This should only be applied to the new word id.
          if ('#{status}' == 'learning')
          {
            addLearningMouseover($(this));
          }
        });
      };

      $(document).ready(ready);
      $(document).on('page:load', ready);

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
    if ['alphanumeric','punctuation'].include? model.category
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


  class ManageWordCell < Word::WordCell

    def show
      render :manage_word
    end

    def type
      'manage'
    end

  end


  class PreviewWordCell < Word::WordCell

    def show
      render :preview_word
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

  class InlineWordCell < Word::WordCell

    def show
      render :inline_word
    end

    def type
      'inline'
    end

  end

end
