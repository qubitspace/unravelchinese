class Definition::Form < Reform::Form

  property :word_id, virtual: true
  property :word, validates: { presence: true }
  property :value, validates: { presence: true }
  property :rank, validates: { numericality: { only_integer: true } }

end
