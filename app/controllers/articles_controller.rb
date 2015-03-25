# Add java to path

# Finish setting up stanford parser

class ArticlesController < ApplicationController
  #after_action :verify_authorized, :except => :index, :show

  def index
    #@articles = Article.order('created_at desc').all
    @articles = policy_scope(Article).order('created_at desc').all
  end

  def show
    @article = tokenized_article params[:id]

    @article.sentences.each do |sentence|
      sentence.untokenized = sentence.value.dup
      sentence.tokens.each do |token|
        sentence.untokenized.slice! token.word.simplified
      end
    end

    @word_statuses = current_user.word_statuses
  end

  def new
    @sources = Source.all
    @article = Article.new

    sentence = @article.sentences.build
  end

  def create
    @article = Article.new(article_params)
    @sources = Source.all
    @article.save ? redirect_to(tokenize_article_path(@article)) : render('new')
  end

  def edit
    @sources = Source.all
    @article = Article.includes(:source).find(params[:id])

    sentence = @article.sentences.build
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params) ? redirect_to(tokenize_article_path(@article))  : render('edit')
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  def add_sentence
    @sentence = @article.sentences.build
  end

  def tokenize
    @article = tokenized_article params[:id]

    @article.sentences.each do |sentence|
      sentence.untokenized = sentence.value.dup
      sentence.tokens.each do |token|
        sentence.untokenized.slice! token.word.simplified
      end
    end

    @word_statuses = current_user.word_statuses
  end

  private

  def tokenized_article id
    Article.includes(
      :source,
      :sentences => [
        { :translations => :source },
        { :tokens => { :word => :definitions } }
      ]).find(id)
  end

  def article_params
    params.require(:article).permit(
      :source_id,
      :link,
      :title,
      :description,
      :body,
      :commentable,
      :publishable
    )
  end
end

