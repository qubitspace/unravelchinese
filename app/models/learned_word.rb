class LearnedWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :word

  enum status: [:known, :unknown, :learning, :watching]

  def self.allowed_statuses
    self.statuses.keys
  end
end
