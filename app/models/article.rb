class Article < ActiveRecord::Base
  include Taggable
  belongs_to :category
  has_many :sections, dependent: :destroy
  has_many :sentences, through: :sections, source: :resource, source_type: Sentence
  has_many :iframes, through: :sections, source: :resource, source_type: Iframe
  has_many :photos, through: :sections, source: :resource, source_type: Photo
  has_many :snippets, through: :sections, source: :resource, source_type: Snippet
  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :iframe
  belongs_to :photo

  belongs_to :source

  def next_sort_order
    max = sections.maximum('sort_order')
    max.blank? ? 0 : max + 1
  end

  def re_sort
    self.sections.each_with_index do |section, i|
      section.sort_order = i
      section.save
    end
  end

 # stats - add averages.
  def get_stats current_user
    stats = {}

    if current_user.present?
      stats[:total_words] = 0

      stats[:distinct_words] = 0
      stats[:distinct_known_words] = 0
      stats[:distinct_learning_words] = 0
      stats[:distinct_watching_words] = 0
      stats[:distinct_unknown_words] = 0

      stats[:total_known_words] = 0
      stats[:total_learning_words] = 0
      stats[:total_watching_words] = 0
      stats[:total_unknown_words] = 0

      stats[:words] = {}

      # TODO: get count (total, distinct, and known) for each hsk level

      sections.each do |section|
        if section.resource_type == 'Sentence'
          sentence = section.resource # Sentences can be cloned so we need do count each section.
          sentence.tokens.each do |token|
            learned_word = current_user.word_statuses[token.word.id]
            status = learned_word.present? ? learned_word.status : 'unknown'
            if !token.word.punctuation?
              stats[:total_words] += 1

              if stats[:words].has_key? token.simplified
                stats[:words][token.simplified][:count] += 1
              else
                stats[:words][token.simplified] = { count: 1, status: status }
                stats[:words][token.simplified][:hsk_character_level] = token.word.hsk_character_level
                stats[:words][token.simplified][:hsk_word_level] = token.word.hsk_word_level
                stats[:words][token.simplified][:character_frequency] = token.word.character_frequency
                stats[:words][token.simplified][:word_frequency] = token.word.word_frequency
                stats[:words][token.simplified][:radical_number] = token.word.radical_number
                stats[:words][token.simplified][:strokes] = token.word.strokes
                stats[:words][token.simplified][:pinyin] = token.word.pinyin

                stats[:distinct_words] += 1
                if status == 'known'
                  stats[:distinct_known_words] += 1
                elsif status == 'learning'
                  stats[:distinct_learning_words] += 1
                elsif status == 'watching'
                  stats[:distinct_watching_words] += 1
                elsif status == 'unknown'
                  stats[:distinct_unknown_words] += 1
                end
              end


              if status == 'known'
                stats[:total_known_words] += 1
              elsif status == 'learning'
                stats[:total_learning_words] += 1
              elsif status == 'watching'
                stats[:total_watching_words] += 1
              elsif status == 'unknown'
                stats[:total_unknown_words] += 1
              end
            end
          end
        end
      end

      stats[:words] = stats[:words].sort_by {|k,v| v[:count]}.reverse
    end

    return stats
  end


  private

end

