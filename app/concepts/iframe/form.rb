class Iframe::Form < Reform::Form

  property :title
  property :youtube_id

  validates :youtube_id,
            :title, presence: true

end
