
class User < ActiveRecord::Base
  acts_as_voter
  has_many :learned_words, -> { includes({ word: :definitions }) }#, dependent: :destroy, -> { includes: { word: :definitions } }
  has_many :words, :through => :learned_words
  has_many :translations
  before_create :confirmation_token

  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true

  def word_statuses
     Hash[ learned_words.map { |learned_word| [learned_word.word_id, learned_word] } ]
  end

  def voted_for_sentence sentence
    vote_count = self.get_voted(Translation).where(translations: { sentence_id: sentence.id }).count
    return vote_count > 0
  end

  def get_stats
    stats = { learned_words: {} }
    stats[:learned_words][:count] = learned_words.count
    stats[:learned_words][:hsk_char_count] = {}
    stats[:learned_words][:hsk_word_count] = {}

    learned_words.each do |learned_word|
      word = learned_word.word
      if word.hsk_character_level.present?
        if stats[:learned_words][:hsk_char_count].has_key? word.hsk_character_level
          stats[:learned_words][:hsk_char_count][word.hsk_character_level] += 1
        else
          stats[:learned_words][:hsk_char_count][word.hsk_character_level] = 1
        end
      end
      if word.hsk_word_level.present?
        if stats[:learned_words][:hsk_word_count].has_key? word.hsk_word_level
          stats[:learned_words][:hsk_word_count][word.hsk_word_level] += 1
        else
          stats[:learned_words][:hsk_word_count][word.hsk_word_level] = 1
        end
      end
    end
    # Break out by different statuses
    # Percent of HSK1-6 known/learning, unknown
    return stats
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  private

  def confirmation_token
    if self.confirm_token.blank?
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end


    # TODO: Change to if there is no no votes for any translations from this sentence
      # select t.id
      # from translations t
      # inner join votes v on t.id = v.votable_id and v.votable_type = 'Translation'
      # where t.sentence_id = 6
      #   and v.voter_id = 1



#class Session::SignIn < Trailblazer::Operation
# def process(params)
#   Monban.signin(params)
#   mark_online_activity!
# end