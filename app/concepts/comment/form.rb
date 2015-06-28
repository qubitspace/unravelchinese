class Comment::Form < Reform::Form
  property :body, validates: { length: { in: 6..160 } }
  property :commentable, validates: { presence: true }
end
