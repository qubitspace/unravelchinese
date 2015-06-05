class Article::Cell < Cell::Concept
  property :title
  property :created_at
  property :source

  def show
    render
  end

  def for_title
    render :title
  end

  private

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

