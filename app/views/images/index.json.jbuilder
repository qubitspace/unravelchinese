json.array!(@images) do |image|
  json.extract! document, :id, :post_id, :file
  json.url image_url(image, format: :json)
end
