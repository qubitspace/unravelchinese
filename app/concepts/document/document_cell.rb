class Document::DocumentCell < Cell::Concept
  property :file
  property :title
  property :created_at

  property :source_id
  property :source do
    property :id
    property :link
    property :name
  end

  include Cell::CreatedAt
  def show
    render :show_document
  end

  private

  def current_user # could be used in the view
    @options[:current_user]
  end

end

