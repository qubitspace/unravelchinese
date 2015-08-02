json.array!(@documents) do |document|
  json.extract! document, :id, :post_id, :file
  json.url document_url(document, format: :json)
end
