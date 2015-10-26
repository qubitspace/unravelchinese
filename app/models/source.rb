class Source < ActiveRecord::Base
  belongs_to :review, :class_name => 'Article'

  has_many :articles, inverse_of: :source
  has_many :sentences, inverse_of: :source
  has_many :translations, inverse_of: :source
end
