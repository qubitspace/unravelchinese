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
        if form[:source_id].present?
          article.source = Source.find form[:source_id]
        else
          article.source.update_attributes form[:source]
        end
        article.save
      end

      # Redirect to manage article to set up sentences
      # Then have a link from the sentence cell to a manage sentence page to add tokenize?
      return redirect_to @form.model
    end
    render action: :new
  end

  def edit
    @form = Article::Form.new(Article.find(params[:id]))
  end

  def update
    # run Article::Update do |o|
    #   return redirect_to o.model
    # end

    #render action: :edit
  end

  def manage
    @article = get_article params[:article_id]

    sentence = Sentence.new(:article_id => @article.id)
    sentence.translations.build
    @sentence_form = Sentence::Form.new(sentence)
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
    article = Article.includes({
      sentences: [
        { words: [:definitions] },
        { translations: [:source] },
        :source
      ]},
      :comments,
      :source
    ).find(id)
  end
end
