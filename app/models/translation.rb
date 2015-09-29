class Translation < ActiveRecord::Base
  acts_as_votable
  belongs_to :sentence
  belongs_to :user
  belongs_to :source

end