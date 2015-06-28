class Tag::Form < Reform::Form

  property :name, validates: { presence: true }

end
