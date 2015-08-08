class Sector < ActiveRecord::Base
  belongs_to :article
  belongs_to :resource, polymorphic: true
end
