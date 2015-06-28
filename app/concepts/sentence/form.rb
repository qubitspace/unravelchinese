class Sentence::Form < Reform::Form

  property :article, validates: { presence: true }
  property :value
  property :end_paragraph

  property :source_id
  property :source, skip_if: :all_blank do
    property :link
    property :name
  end

  collection :translations do

    property :value

    property :source_id
    property :source, skip_if: :all_blank do
      property :link
      property :name
    end
  end

end

