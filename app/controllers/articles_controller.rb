class ArticlesController < ApplicationController
  #after_action :verify_authorized, :except => :index, :show

  def index
    #@articles = Article.order('created_at desc').all
    @articles = policy_scope(Article).order('created_at desc').all
  end

  def show
    @article = tokenized_article params[:id]

    @words = {}
    @stats = {}
    @stats[:total_words] = 0
    @stats[:distinct_words] = 0

    @article.sentences.each do |sentence|
      sentence.tokens.each do |token|
        if !token.word.punctuation?
          @stats[:total_words] += 1
          if @words.has_key? token.simplified
            @words[token.simplified] += 1
          else
            @words[token.simplified] = 1
            @stats[:distinct_words] += 1
          end
        end
      end
    end
    @words = @words.sort_by {|k,v| v}.reverse

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

