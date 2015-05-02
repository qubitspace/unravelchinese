class Article < ActiveRecord::Base
  include Taggable
  has_many :sentences, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :source, :class_name => 'Source'
  accepts_nested_attributes_for :source, :reject_if => :all_blank

  validates :title, presence: true, uniqueness: true
  validates :source, presence: true
  validates :published, inclusion: { in: [true, false] }

  accepts_nested_attributes_for :source

  before_save :clean_quotes

  def next_rank
    sentences.count == 0 ? 0 : sentences.maximum('rank') + 1
  end

  def get_stats word_statuses
    stats = {}
    stats[:total_words] = 0
    stats[:distinct_words] = 0
    stats[:known_words] = 0
    stats[:words] = {}

    sentences.each do |sentence|
      sentence.tokens.each do |token|
        known = word_statuses.include? token.word.id
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

  def clean_quotes
    if self.description.present?
      self.description.gsub!(/[“”]/, '"')
      self.description.gsub!(/[’]/, "'")
    end
  end
end

