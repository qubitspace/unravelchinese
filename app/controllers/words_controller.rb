class WordsController < ApplicationController

  def index
    @results = Word.none
  end

  def find
    @results = Word.find_words(params[:simplified], params[:traditional], params[:pinyin])
    redirect_to @results[0] if @results.count == 1
  end

  def search
    @term = params[:term]
    @match_accents = params[:match_accents]
    @results = Word.search(@term, @match_accents)
    respond_to do |format|
      format.js
    end
  end

  def search_by_definition
    @term = params[:term]
    @results = Word.definition_search(@term)
    respond_to do |format|
      format.js
    end
  end

  def show
    @word = Word.find(params[:id])

    @derived_words = Word.order('-hsk_character_level desc')
      .search(@word.simplified).select { |word| word != @word }
      .first(5)
    @sub_words = Word.order('-hsk_character_level desc')
      .where(simplified: split_word(@word.simplified))
      .select { |word| word != @word }
      .first(3)
    @synonyms = Word.where(pinyin: @word.pinyin).first(3)
    @sentences = Sentence.where(['value LIKE ?', "%#{@word.simplified}%"]).first(3)
    @articles = @sentences.collect { |sentence| sentence.article }.uniq{ |article| article.id }.first(3)
  end

  def split_word word
    (0..word.length).inject([]){|ai,i|
      (1..word.length - i).inject(ai){|aj,j|
        aj << word[i,j]
      }
    }.uniq
  end

  def update_status
    @word = Word.find(params[:word_id])
    @word.update_status current_user, params[:status]

    unless params[:article_id].nil?
      @article = Article.find(params[:article_id])
      @stats = @article.get_stats current_user
    end

    respond_to do |format|
      format.js
    end
  end


end
