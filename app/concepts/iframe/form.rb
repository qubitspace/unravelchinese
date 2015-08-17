class Iframe::Form < Reform::Form

  property :url
  property :title
  property :description

  validates :url,
            :title, presence: true

end
