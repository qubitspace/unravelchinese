class Snippet::Form < Reform::Form

  property :content
  property :format

  validates :content, :format, presence: true

end
