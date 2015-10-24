class Iframe::IframeCell < Cell::Concept
  include Cell::ManageableCell

  property :youtube_id
  property :title
  property :description
  property :created_at

  private

  # Manage
  class Manage < Iframe::IframeCell
  end

  # List
  class List < Iframe::IframeCell
  end

  # Inline
  class Inline < Iframe::IframeCell
  end

end

