class Article < ActiveRecord::Base
  include Taggable
  has_many :sentences, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :source

  def next_rank
    sentences.count == 0 ? 0 : sentences.maximum('rank') + 1
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

