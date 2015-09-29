class Photo::Form < Reform::Form

  property :file
  property :title
  property :description
  property :source_name
  property :source_link

  validates :file,
            :title, presence: true

end
