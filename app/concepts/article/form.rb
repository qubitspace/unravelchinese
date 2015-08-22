class Article::Form < Reform::Form

  property :title, validates: { uniqueness: true }
  property :description
  property :published
  property :commentable

  property :source, virtual: true, validates: { presence: true }

  validates :title,
            :description,
            :published,
            :commentable,
            :source, presence: true

end
