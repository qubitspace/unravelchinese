class Definition::Form < Reform::Form

  property :word_id, virtual: true
  property :word, validates: { presence: true }
  property :value, validates: { presence: true }
  property :sort_order, validates: { numericality: { only_integer: true } }

end
