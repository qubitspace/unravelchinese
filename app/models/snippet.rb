class Snippet < ActiveRecord::Base
  belongs_to :sector, as: :resource, dependent: :destroy
  belongs_to :article, through: :sector
end