class Snippet::Form < Reform::Form

  property :section do
    property :article_id, validates: { presence: true }
  end

  property :content, validates: { presence: true }
  property :render_type, validates: { presence: true }

end
