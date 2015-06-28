class Definition::Form < Reform::Form

  property :word, validates: { presence: true }
  property :value, validates: { presence: true }
  property :rank

end
