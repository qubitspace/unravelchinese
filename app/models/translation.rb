class Translation < ActiveRecord::Base
  acts_as_votable
  belongs_to :source
  belongs_to :sentence
  belongs_to :user

end