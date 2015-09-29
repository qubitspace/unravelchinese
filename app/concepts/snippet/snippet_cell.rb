class Snippet::SnippetCell < Cell::Concept
  include Cell::ManageableCell
  include Escaped

  property :content
  property :render_type
  property :html?
  property :redcloth?
  property :raw?

  private

  def html_content
    content(escape: false)
  end

  class Manage < Snippet::SnippetCell
  end

  class Inline < Snippet::SnippetCell
  end

end

