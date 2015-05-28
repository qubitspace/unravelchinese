class ArticlesController < ApplicationController
  #after_action :verify_authorized, :except => :index, :show

  def index
    #@articles = Article.order('created_at desc').all
    @articles = policy_scope(Article).order('created_at desc').all
  end

  def show
    @article = tokenized_article params[:id]
    @stats = @article.get_stats current_user
  end

  def update_word_status
    @word = Word.find(params[:word_id])
    @word.update_status current_user, params[:status]

    @article = Article.find(params[:article_id])
    @stats = @article.get_stats current_user

    respond_to do |format|
      format.js
    end
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

