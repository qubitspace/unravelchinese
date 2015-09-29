class Sentence::Form < Reform::Form

  property :section do
    property :article_id, validates: { presence: true }
  end

  property :value, validates: { presence: true }
  property :translatable
  property :auto_translate
  property :start_time
  property :end_time

  collection :translations, skip_if: :all_blank do
    property :value
  end

end

