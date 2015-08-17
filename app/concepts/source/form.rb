class Source::Form < Reform::Form

  property :name
  property :link
  property :disabled
  property :restricted

  validates :name, :link, presence: true

end
