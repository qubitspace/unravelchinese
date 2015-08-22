class Sentence::Form < Reform::Form

  property :section do
    property :article_id, validates: { presence: true }
  end

  property :value, validates: { presence: true }

  collection :translations do
    property :value, validates: { presence: true }
    property :category, validates: { presence: true }
  end

end

