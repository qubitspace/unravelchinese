class User < ActiveRecord::Base
  has_many :learned_words, dependent: :destroy
  has_many :words, :through => :learned_words
  has_many :translations

  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  # Add username
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }, unless: "password.nil?"
  validates :password, presence: true, if: "id.nil?"

  def word_statuses
     Hash[ learned_words.map { |learned_word| [learned_word.word_id, learned_word] } ]
   end
end
