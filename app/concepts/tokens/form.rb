class Token::Form < Reform::Form

  property :sort_order, validates: { presence: true }
  property :start_time
  property :end_time

end
