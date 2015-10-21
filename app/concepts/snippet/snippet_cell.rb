class Snippet::SnippetCell < Cell::Concept
  include Cell::ManageableCell
  include Escaped

  property :content
  property :render_type
  property :html?
  property :redcloth?
  property :raw?

  private

  def rendered_content
    if html?
      content(escape: false)
    elsif redcloth?
      content
    elsif raw?
      content
    end
  end

  class Manage < Snippet::SnippetCell
  end

  class Inline < Snippet::SnippetCell
  end

end

