class Sentence::Form < Reform::Form

  property :section do
    property :article_id, validates: { presence: true }
  end

  property :value, validates: { presence: true }

  collection :translations do

    property :value, validates: { presence: true }

    property :source_id, virtual: true,
                validates: {
                  presence: { message: "required if a new source name and link is not specified" },
                  if: "source.name.blank? or source.link.blank?"
                }

    property :source do
      property :name
      property :link
    end

  end

end

