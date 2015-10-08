class Section::Form < Reform::Form

  property :article_id, validates: { presence: true }
  property :resource_id
  property :resource_type
  property :container
  property :alignment
  property :end_paragraph
  property :start_time
  property :end_time
  property :offsets, virtual: true

  property :sentence, skip_if: :all_blank, populate_if_empty: Sentence do
    property :value
    collection :translations, skip_if: :all_blank, populate_if_empty: Translation do
      property :value
    end
  end

  property :snippet, skip_if: :all_blank, populate_if_empty: Snippet do
    property :content
    property :render_type
  end

  property :photo_id, virtual: true
  property :iframe_id, virtual: true


end

