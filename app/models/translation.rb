class Translation < ActiveRecord::Base
  belongs_to :source
  belongs_to :sentence

end