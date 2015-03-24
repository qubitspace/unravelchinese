class Source < ActiveRecord::Base
  has_many :articles, inverse_of: :source
  has_many :translations
end
