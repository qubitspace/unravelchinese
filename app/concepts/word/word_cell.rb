###TODO
# Can probably share views better.
# Preview and search result can share a view
  # Instead of using link and highlight methods, just call Simplified/Traditional/Pinyin and each class knows what to do.

class Word::WordCell < Cell::Concept
  include Cell::ManageableCell

  property :simplified
  property :traditional
  property :pinyin
  property :type
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

  def status
    if ['alphanumeric','punctuation'].include? model.type
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

  # Show
  class Show < Word::WordCell
  end

  # Manage
  class Manage < Word::WordCell
  end

  # Preview
  class Preview < Word::WordCell
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

  end

  # List > Search
  class Search < Word::WordCell::List

    def show
      render :preview_word
    end

    private

    def query
      @options[:query]
    end

    def simplified
      link(highlight model.simplified)
    end

    def traditional
      link(highlight model.traditional)
    end

    def pinyin
      link(highlight model.pinyin)
    end

    def highlight value
      Word.highlight(value, query)
    end

    def update_status_path status
      word_update_status_path word_id: id, status: status, query: query
    end
  end


end
