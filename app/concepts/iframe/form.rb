class Iframe::Form < Reform::Form

  property :url
  property :title

  validates :url,
            :title, presence: true

end
