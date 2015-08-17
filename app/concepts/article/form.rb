class Article::Form < Reform::Form

  property :link
  property :title, validates: { uniqueness: true }
  property :description
  property :published
  property :commentable

  property :source, virtual: true, validates: { presence: true }

  # property :source do
  #   property :name
  #   property :link
  # end

  validates :link,
            :title,
            :description,
            :published,
            :commentable,
            :source, presence: true

end
