class Source::SourceCell < Cell::Concept
  include Cell::ManageableCell

  property :name
  property :link
  property :disabled
  property :restricted

  private

  # Manage
  class Manage < Source::SourceCell
  end

  # List
  class List < Source::SourceCell
  end

  # Inline
  class Inline < Source::SourceCell
  end

end

