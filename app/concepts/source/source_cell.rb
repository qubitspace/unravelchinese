class Source::SourceCell < Cell::Concept
  property :article
  property :name
  property :link
  property :disabled
  property :restricted

  include Cell::CreatedAt
  def show
    render :show_source
  end

  private

  def current_user # could be used in the view
    @options[:current_user]
  end

  def resource
    # the file or link depending on the type
  end

end

