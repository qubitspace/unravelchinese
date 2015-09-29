class Photo::PhotoCell < Cell::Concept
  include Cell::ManageableCell

  property :file
  property :title
  property :description
  property :source_name
  property :source_link
  property :created_at

  private

  # Manage
  class Manage < Photo::PhotoCell
  end

  # List
  class List < Photo::PhotoCell
  end

  # Inline
  class Inline < Photo::PhotoCell
  end

end

