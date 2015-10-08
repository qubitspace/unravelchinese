class Article::ArticleCell < Cell::Concept
  include Cell::ManageableCell
  include Cell::CreatedAt

  property :category_id

  property :title
  property :description
  property :iframe
  property :photo

  property :source_id
  property :source do
    property :id
    property :name
  end

  property :sections do
    property :resource
  end

  property :commentable
  property :published

  property :content_source_link
  property :content_source_name
  property :translation_source_link
  property :translation_source_name


  private

  # Show
  class Show < Article::ArticleCell
  end

  # Manage
  class Manage < Article::ArticleCell
  end

  # List
  class List < Article::ArticleCell
  end

  # Inline
  class Inline < Article::ArticleCell
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

  def resort_link
    link_to "Resort", resort_article_path(model), method: :put
  end

  def sentence_form
    @options[:sentence_form]
  end

end

