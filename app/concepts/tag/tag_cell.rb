class Tag::TagCell < Cell::Concept
  include Cell::ManageableCell

  property :name

  private

  # Show
  class Show < Tag::TagCell
  end

  # Manage
  class Manage < Tag::TagCell
  end

  # List
  class List < Tag::TagCell
    property :taggable_count
  end

  # Inline
  class Inline < Tag::TagCell
  end

end

