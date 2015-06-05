class Article::Cell < Cell::Concept
  property :title
  property :created_at
  property :source
  property :description

  # include Cell::CreatedAt
  def show
    render
  end

  def for_title
    render(:title).html_safe
  end

  private

  def sentences
    # talk about why we don't need an Operation, yet, to collect comments here.
    @sentences ||= model.sentences
  end

  def comments
    # talk about why we don't need an Operation, yet, to collect comments here.
    @comments ||= model.comments#.page(page).per(10)
  end

  def name_link
    link_to title, article_path(model)
  end

  def has_source?
    source != nil
  end

  def source_link
    link_to(source.name, source.link) if source
  end

  def current_user # could be used in the view
    @options[:current_user]
  end

  class Preview < Article::Cell

    # include Kaminari::Cells
    # include ActionView::Helpers::JavaScriptHelper

    #property :title
    #property :created_at

    def show
      render :preview
    end

    #include Cell::GridCell
    #self.classes = ["box", "large-3", "columns"]

    #include Cell::CreatedAt

    private

    def name_link
      link_to title, article_path(model)
    end
  end

end

