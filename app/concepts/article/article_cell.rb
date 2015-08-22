class Article::ArticleCell < Cell::Concept
  property :title
  property :description

  property :created_at

  property :source_id
  property :source do
    property :id
    property :name
  end

  property :sections do
    property :resource
  end

  include Cell::CreatedAt
  def show
    render :show_article
  end

  def show_header
    render :show_header
  end

  private

  def comments
    # talk about why we don't need an Operation, yet, to collect comments here.
    @comments ||= model.comments#.page(page).per(10)
  end

  def name_link
    link_to title, article_path(model)
  end

  def source_link
    link_to(source.name, source.link)# if source
  end

  def commentable
    model.commentable
  end

  def current_user # could be used in the view
    @options[:current_user]
  end

  class PreviewArticleCell < Article::ArticleCell

    # include Kaminari::Cells
    # include ActionView::Helpers::JavaScriptHelper

    #property :title
    #property :created_at

    def show
      render :preview_article
    end

    #include Cell::GridCell
    #self.classes = ["box", "large-3", "columns"]

    #include Cell::CreatedAt


    private


    def name_link
      link_to title, article_path(model)
    end

  end

  class ManageArticleCell < Article::ArticleCell
    def show
      render :manage_article
    end
  end

end

