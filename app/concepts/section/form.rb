class Section::Form < Reform::Form

  property :article, validates: { presence: true }
  property :resource_id, validates: { presence: true }
  property :resource_type, validates: { presence: true }

end

