class Token::Form < Reform::Form

  property :sort_order, validates: { presence: true }

end
