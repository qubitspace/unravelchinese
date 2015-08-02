class Document < ActiveRecord::Base
  has_many :attachments, dependent: :destroy
  has_many :posts, through: :attachments, source: :attachable, source_type: Post
  belongs_to :source
  mount_uploader :file, AvatarUploader
end
