class Snippet < ActiveRecord::Base
  has_one :section, as: :resource, dependent: :destroy
  has_many :articles, through: :sections
end