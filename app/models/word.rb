require "i18n"

class Word < ActiveRecord::Base
  include Taggable

  has_many :tokens, dependent: :destroy
  has_many :sentences, through: :tokens

  has_many :taggings, :class_name => 'Tagging', :foreign_key => 'taggable_id'
  has_many :tags, through: :taggings, dependent: :destroy, :source => :taggable, :source_type => "Word"
  has_many :definitions, -> { order 'sort_order asc' }, dependent: :destroy

  enum type: { uncategorized: 0, punctuation: 1, alphanumeric: 2, word: 3, character: 4, radical: 5 }
  validates :simplified, length: { minimum: 1 }

  def self.find_words simplified, traditional, pinyin
    @words = self.find_words simplified, traditional, pinyin
  end

  def self.find_word simplified, traditional, pinyin
    limit = 100
    results = self.includes(:definitions) # simplified and (!traditional.present? or t)
      .where('simplified = ? and (? = false or traditional = ?) and (? = false or pinyin_cs = ?)', simplified, traditional.present?, traditional, pinyin.present?, pinyin)
      .limit(limit)
      .order("-hsk_character_level desc, -hsk_word_level desc, -character_frequency desc, -word_frequency desc, -strokes desc, -radical_number desc, noun asc")
    if results.count == 1
      redirect_to results[0]
    else
      results
    end
  end

  def self.search term, exact_match = 0

    if term and term != ''
      term = term.split(' ').map { |t| self.pinyinize t }.join('')

      if exact_match
        results = self.case_sensitive_search term
      else
        results = self.case_insensitive_search term
      end
    else
      results = self.none
    end
    return results
  end

  def self.definition_search term
    limit = 100
    exact_matches = self.joins([:definitions]).where('definitions.value = ?', term).limit(limit).order(
      "-hsk_character_level desc, -hsk_word_level desc, -character_frequency desc, -word_frequency desc, -strokes desc, -radical_number desc, noun asc"
    )

    wildcard = "%#{term}%"
    partial_match_limit = limit - exact_matches.count
    partial_matches = self.joins([:definitions]).where('definitions.value like ? and id not in (?)', wildcard, exact_matches.map(&:id)).limit(limit).order(
      "-hsk_character_level desc, -hsk_word_level desc, -character_frequency desc, -word_frequency desc, -strokes desc, -radical_number desc, noun asc"
    )
    results = exact_matches
    return results
  end

  def self.highlight value, term, match_accents = false

    if term and term != ''
      term = term.split(' ').map { |t| self.pinyinize t }.join('')
      term = pinyinize term if validate term

      matches = []
      return nil if value.nil? or term.nil?
      if match_accents
        normalized_value = value
        normalized_term = term
      else
        normalized_value = I18n.transliterate(value).downcase
        normalized_term = I18n.transliterate(term).downcase
      end

      normalized_value.scan(normalized_term) do |c|
        matches << $~.offset(0)[0]
      end
      matches.reverse.each do |i|
        match = value[i,term.length]
        value[i, term.length] = "<mark>#{match}</mark>"
      end
    end
    return value.html_safe
  end


  def self.highlight_definition value, term

    if term and term != ''

      matches = []
      return nil if value.nil? or term.nil?

      value.scan(term) do |c|
        matches << $~.offset(0)[0]
      end
      matches.reverse.each do |i|
        match = value[i,term.length]
        value[i, term.length] = "<mark>#{match}</mark>"
      end
    end
    return value.html_safe
  end

  def taggable_type
    'Word'
  end

  private


  @@accents = {
    'a' => ['ā', 'á', 'ǎ', 'à'],
    'e' => ['ē', 'é', 'ě', 'è'],
    'i' => ['ī', 'í', 'ǐ', 'ì'],
    'o' => ['ō', 'ó', 'ǒ', 'ò'],
    'u' => ['ū', 'ú', 'ǔ', 'ù'],
    'ü' => ['ǖ', 'ǘ', 'ǚ', 'ǚ'],
    'A' => ['Ā', 'Á', 'Ǎ', 'À'],
    'E' => ['Ē', 'É', 'Ě', 'È'],
    'I' => ['Ī', 'Í', 'Ǐ', 'Ì'],
    'O' => ['Ō', 'Ó', 'Ǒ', 'Ò'],
    'U' => ['Ū', 'Ú', 'Ǔ', 'Ù'],
    'Ü' => ['Ǖ', 'Ǘ', 'Ǚ', 'Ǜ'],
  }

  @@vowels = ['a', 'e', 'i', 'o', 'u', 'ü', 'A', 'E', 'I', 'O', 'U', 'Ü']
  @@medials = ['i', 'u', 'ü','I', 'U', 'Ü']

  def self.find_words simplified, traditional, pinyin
    limit = 100

    search_terms = {}
    search_terms[:simplified] = simplified
    search_terms[:traditional] = traditional if traditional.present?
    search_terms[:pinyin_cs] = pinyin if pinyin.present?
    results = self.includes(:definitions)
      .where(search_terms)
      .limit(limit).order("-hsk_character_level desc, -hsk_word_level desc, -character_frequency desc, -word_frequency desc, -strokes desc, -radical_number desc, noun asc")
    return results
  end

  def self.case_sensitive_search term
    limit = 100
    exact_matches = self.includes(:definitions)
      .where('simplified = ? or traditional = ? or pinyin_cs = ?', term, term, term)
      .limit(limit)
      .order("-hsk_character_level desc, -hsk_word_level desc, -character_frequency desc, -word_frequency desc, -strokes desc, -radical_number desc, noun asc")

    wildcard = "%#{term}%"
    partial_match_limit = limit - exact_matches.count
    partial_matches = self.includes(:definitions)
      .where('simplified like ? or traditional like ? or pinyin_cs like ?', wildcard, wildcard, wildcard)
      .where('id not in (?)', exact_matches.map(&:id))
      .limit(partial_match_limit)
      .order("-hsk_character_level desc, -hsk_word_level desc, -character_frequency desc, -word_frequency desc, -strokes desc, -radical_number desc, noun asc")
    results = exact_matches + partial_matches
    return results
  end

  def self.case_insensitive_search term
    limit = 100
    exact_matches = self.includes(:definitions)
      .where('simplified = ? or traditional = ? or pinyin = ?', term, term, term)
      .limit(limit)
      .order("-hsk_character_level desc, -hsk_word_level desc, -character_frequency desc, -word_frequency desc, -strokes desc, -radical_number desc, noun asc")

    wildcard = "%#{term}%"
    partial_match_limit = limit - exact_matches.count
    partial_matches = self.includes(:definitions)
      .where('simplified like ? or traditional like ? or pinyin like ?', wildcard, wildcard, wildcard)
      .where('id not in (?)', exact_matches.map(&:id))
      .limit(partial_match_limit)
      .order("-hsk_character_level desc, -hsk_word_level desc, -character_frequency desc, -word_frequency desc, -strokes desc, -radical_number desc, noun asc")
    results = exact_matches + partial_matches
    return results
  end

  def self.vowel_count word
    vowel_count = 0
    word.each_char do |c|
      vowel_count += 1 if @@vowels.include? c
    end
    vowel_count
  end

  def self.add_accent word, char_index, tone
    accent_letter = word[char_index]
    if @@accents.has_key? accent_letter
      word[char_index] = @@accents[accent_letter][tone-1]
    end
    word
  end

  def self.is_vowel c
    @@vowels.include? c
  end

  def self.is_medial c
    @@medials.include? c
  end

  def self.add_tone word, tone
    if [1,2,3,4].include? tone
      finished = false
      if vowel_count(word) == 1
        i = 0
        word.each_char do |c|
          if !finished and @@vowels.include? c
            add_accent word, i, tone
            finished = true
          end
          i += 1
        end
      else
        medial_found = false
        i = 0
        word.each_char do |c|
          if !finished and is_vowel(c) and (medial_found or !is_medial(c))
            add_accent word, i, tone
            finished = true
          end
          medial_found = true if is_medial(c)
          i += 1
        end
      end
    end
    word
  end

  def self.validate word
    ['1','2','3','4','5'].include? word[-1]
  end

  # http://web.mit.edu/jinzhang/www/pinyin/spellingrules/
  def self.pinyinize word
    word = word.gsub 'u:', 'ü'
    if validate(word)
      tone = word[-1]
      word = word[0...-1]
      word = add_tone word, tone.to_i
    end
    return word
  end

end


