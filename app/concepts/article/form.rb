class Article::Form < Reform::Form

  property :title, validates: { uniqueness: true, presence: true }
  property :description
  property :source, virtual: true # TODO: Should this be virtual?
  property :category
  property :iframe_id
  property :photo_id

  property :published
  property :commentable

  property :content_source_link
  property :content_source_name
  property :translation_source_link
  property :translation_source_name

end
