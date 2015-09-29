class Snippet < ActiveRecord::Base
  has_one :section, as: :resource, dependent: :destroy
  has_many :articles, through: :sections

  enum render_type: { html: 0, redcloth: 1, raw: 2 }
end