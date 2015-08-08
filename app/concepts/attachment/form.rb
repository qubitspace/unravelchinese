class Attachment::Form < Reform::Form
  property :document_id, validates: { presence: true }
  property :attachable, validates: { presence: true }
end
