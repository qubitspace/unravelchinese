class Source::Form < Reform::Form

  property :name
  property :link
  property :review_id
  property :disabled
  property :restricted

  validates :name, :link, presence: true

end
