class Category::Form < Reform::Form

  property :name, validates: { presence: true }

end
