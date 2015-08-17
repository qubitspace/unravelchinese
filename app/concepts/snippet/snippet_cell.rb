class Snippet::SnippetCell < Cell::Concept
  include Escaped
  include Cell::CreatedAt
  property :content
  property :format

  def show
    render :show_snippet
  end

  private

  def html_content
    content(escape: false)
  end

  def current_user # could be used in the view
    @options[:current_user]
  end

end

