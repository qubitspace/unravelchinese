class Document < ActiveRecord::Base
  belongs_to :sector, as: :resource, dependent: :destroy
  belongs_to :article, through: :sector
  belongs_to :source
  mount_uploader :file, AvatarUploader
  enum type: [:image]
end
