class ArticlesController < ApplicationController

  def index
    authorize :articles, :index?
    @articles = policy_scope(Article).order('created_at desc').all
  end

  def show
    @article = get_article params[:id]
    @form = Comment::Form.new(Comment.new)
  end

  def new
    @form = Article::Form.new(new_article)
  end

  def create
    @form = Article::Form.new(new_article)

    if @form.validate(params[:article])
      @form.sync
      article = @form.model

      @form.save do |form|
        article.source = Source.find form[:source]
        article.save
      end

      # Redirect to manage article to set up sentences
      # Then have a link from the sentence cell to a manage sentence page to add tokenize?
      return redirect_to @form.model
    end
    render action: :new
  end

  def edit
    @form = Article::Form.new(Article.includes(:source).find(params[:id]))
  end


  def update
    @article = Article.includes(:source).find(params[:id])
    @form = Article::Form.new(@article)


    if @form.validate(params[:article])
      @form.sync
      article = @form.model

      @form.save do |form|
        article.source = Source.find form[:source]
        article.save
      end

      # Redirect to manage article to set up sentences
      # Then have a link from the sentence cell to a manage sentence page to add tokenize?
      return redirect_to @form.model
    end

    render :edit
  end

  def manage
    @article = get_article params[:article_id]

    sentence = Sentence.new(:section => Section.new(:article_id => @article.id))
    sentence.translations.build
    @sentence_form = Sentence::Form.new(sentence)
    @add_image_form = Section::Form.new(Section.new)
    @add_iframe_form = Section::Form.new(Section.new)
  end

  def add_iframe
    @article = Article.find params[:id]
    @form = Section::Form.new(Section.new)
    @form.article = @article
    if @form.validate(params[:section])
      @form.save
      flash[:notice] = "Created section"
      return redirect_to article_manage_path(@article)
    end

    render :manage
  end

  def create_comment
    @article = Article.find params[:id]
    @form = Comment::Form.new(Comment.new)
    @form.commentable = @article
    if @form.validate(params[:comment])
      @form.save
      flash[:notice] = "Created comment for \"#{@article.title}\""
      return redirect_to article_path(@article)
    end

    render :show
  end


  def next_comments
    present Article::Update
    # using .(:append) will mark the results as html safe and applies caching
    render js: concept("comment/comment_cell/comment_grid", @article, page: params[:page]).(:append)
  end

  private

  def new_article
    Article.new(source: Source.new)
  end

  def new_sentence
    Sentence.new(translation: Translation.new)
  end

  def get_article id
    Article.includes({
        # sentences: [
        #     :source,
        #     { translations: :source },
        #     { tokens: { word: :definitions }}
        #   ],
        sections: :resource
      },
      :comments,
      :source
    ).find(id)
  end
end
