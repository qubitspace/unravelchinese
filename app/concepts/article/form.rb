class Article::Form < Reform::Form

  property :title, validates: { uniqueness: true, presence: true }
  property :description
  property :iframe_id
  property :image_id

  property :published
  property :commentable
  property :source, virtual: true

end
