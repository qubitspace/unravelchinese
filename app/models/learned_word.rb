class LearnedWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :word

  enum status: [:known, :unknown, :learning] 
end
