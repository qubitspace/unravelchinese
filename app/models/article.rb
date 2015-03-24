class Article < ActiveRecord::Base
  include Taggable
  has_many :sentences, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :source

  validates :title, presence: true, uniqueness: true
  validates :source, presence: true
  validates :published, inclusion: { in: [true, false] }

  accepts_nested_attributes_for :sentences, reject_if: proc { |sentence| sentence['value'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :source

  def next_rank
    sentences.count == 0 ? 0 : sentences.maximum('rank') + 1
  end
end

