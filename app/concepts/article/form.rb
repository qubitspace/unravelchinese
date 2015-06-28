class Article::Form < Reform::Form

  property :link
  property :title
  property :description
  property :published
  property :commentable

  property :source_id, virtual: true,
              validates: {
                presence: { message: "required if a new source name and link is not specified" },
                if: "source.name.blank? or source.link.blank?"
              }

  property :source do
    property :name
    property :link
  end

  validates :link,
            :title,
            :description,
            :published,
            :commentable,
            :source, presence: true

end
