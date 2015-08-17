class Image < ActiveRecord::Base
  has_many :sections, as: :resource, dependent: :destroy
  has_many :articles, through: :sections
  belongs_to :source
  mount_uploader :file, AvatarUploader
end
