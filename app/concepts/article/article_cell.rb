class Article::ArticleCell < Cell::Concept
  property :title
  property :created_at
  property :description

  property :source_id
  property :source do
    property :id
    property :link
    property :name
  end

  include Cell::CreatedAt
  def show
    render :article_show
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

  def source_link
    link_to(source.name, source.link)# if source
  end

  def commentable
    model.commentable
  end

  def current_user # could be used in the view
    @options[:current_user]
  end

  class ArticlePreviewCell < Article::ArticleCell

    # include Kaminari::Cells
    # include ActionView::Helpers::JavaScriptHelper

    #property :title
    #property :created_at

    def show
      render :article_preview
    end

    #include Cell::GridCell
    #self.classes = ["box", "large-3", "columns"]

    #include Cell::CreatedAt


    private


    def name_link
      link_to title, article_path(model)
    end

  end

  class ArticleManage < Article::ArticleCell
    def show
      render :article_manage
    end
  end

end

