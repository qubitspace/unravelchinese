class Image::Form < Reform::Form

  property :file
  property :title
  property :description
  property :source_id

  validates :file,
            :title,
            :source_id, presence: true

end
