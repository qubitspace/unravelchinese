class Article < ActiveRecord::Base
  include Taggable
  has_many :sentences, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :source

  validates :title, presence: true, uniqueness: true
  validates :source, presence: true
  validates :published, inclusion: { in: [true, false] }

  accepts_nested_attributes_for :source

  before_save :clean_quotes

  def next_rank
    sentences.count == 0 ? 0 : sentences.maximum('rank') + 1
  end

  private

  def clean_quotes
    if self.description.present?
      self.description.gsub!(/[“”]/, '"')
      self.description.gsub!(/[’]/, "'")
    end
  end
end

