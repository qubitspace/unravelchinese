class Document::Form < Reform::Form

  property :file
  property :link
  property :title

  property :source_id, virtual: true,
              validates: {
                presence: { message: "required if a new source name and link is not specified" },
                if: "source.name.blank? or source.link.blank?"
              }

  property :source do
    property :name
    property :link
  end

  validates :file,
            :title,
            :source, presence: true

end
