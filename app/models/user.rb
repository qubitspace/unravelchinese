
class User < ActiveRecord::Base
  acts_as_voter
  has_many :learned_words, dependent: :destroy
  has_many :words, :through => :learned_words
  has_many :translations

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