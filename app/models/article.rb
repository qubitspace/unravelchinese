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
    sentences.count == 0 ? 0 : sentences.maximum('sort_order') + 1
  end

  def resort
    self.sections.each_with_index do |section, i|
      section.sort_order = i
      section.save
    end
  end

  def get_stats current_user
    stats = {}
    stats[:total_words] = 0
    stats[:distinct_words] = 0
    stats[:known_words] = 0
    stats[:words] = {}

    sentences.each do |sentence|
      sentence.tokens.each do |token|
        known = current_user.word_statuses.include? token.word.id
        if !token.word.punctuation?
          stats[:total_words] += 1
          if stats[:words].has_key? token.simplified
            stats[:words][token.simplified][:count] += 1
          else
            stats[:words][token.simplified] = { count: 1, known: known }
            stats[:distinct_words] += 1
          end
          if known
            stats[:known_words] += 1
          end
        end
      end
    end

    stats[:words] = stats[:words].sort_by {|k,v| v[:count]}.reverse
    return stats
  end

  private

end

