require "i18n"

class Word < ActiveRecord::Base
  has_many :tokens, dependent: :destroy
  has_many :sentences, through: :tokens
  has_many :definitions, dependent: :destroy

  enum category: [:uncategorized, :punctuation, :alphanumeric, :word, :character, :radical, ]
  validates :simplified, length: { minimum: 1 }

  has_many :taggings, through: :definitions

  def self.search term
    if term
      limit = 100
      exact_matches = self.where('simplified = ? or traditional = ? or pinyin = ?', term, term, term).limit(limit)
      
      wildcard = "%#{term}%"
      partial_match_limit = limit - exact_matches.count
      partial_matches = self.where('simplified LIKE ? or traditional like ? or pinyin like ?', wildcard, wildcard, wildcard).limit(partial_match_limit)
      results = exact_matches + partial_matches
    else
      results = self.all.limit(100)
    end
    return results
  end

  #TODO: automaticaly pinyinize words that have a number at the end
  #TODO: doesn't match if pinyin included in serch term
  #TODO: It's not matching all accents (ǎ) need a lacale that doesn't have that character?

  def self.highlight value, term
    matches = []
    normalized = I18n.transliterate(value).downcase
    normalized.scan(term.downcase) do |c|
      matches << $~.offset(0)[0]
    end
    matches.reverse.each do |i|
      match = value[i,3]
      value[i, term.length] = "<mark>#{match}</mark>"
    end
    return value.html_safe
  end
end


