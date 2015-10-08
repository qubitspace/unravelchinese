class Category::CategoryCell < Cell::Concept
  include Cell::ManageableCell

  property :name

  private

  # Show
  class Show < Category::CategoryCell
  end

  # Manage
  class Manage < Category::CategoryCell
  end

  # List
  class List < Category::CategoryCell
  end

  # Inline
  class Inline < Tag::TagCell
  end

end

