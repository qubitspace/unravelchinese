class Translation < ActiveRecord::Base
  default_scope { order('cached_votes_score desc') }
  acts_as_votable
  belongs_to :sentence
  belongs_to :user
  belongs_to :source

end