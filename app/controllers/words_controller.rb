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

  def definition_search
    @term = params[:term]
    @results = Word.definition_search(@term)
    respond_to do |format|
      format.js
    end
  end

  def show
    # move some of this stuff into the word model
    @word = Word.find(params[:id])
    @word_statuses = current_user.word_statuses
    @derived_words = Word.order('-hsk_character_level desc').search(@word.simplified).select { |word| word != @word }
    @sub_words = Word.order('-hsk_character_level desc').where(simplified: split_word(@word.simplified)).select { |word| word != @word }
    @synonyms = Word.where(pinyin: @word.pinyin)
    @sentences = Sentence.where(['value LIKE ?', "%#{@word.simplified}%"])
    @articles = @sentences.collect { |sentence| sentence.article }.uniq{ |article| article.id }
  end

  def split_word word
    (0..word.length).inject([]){|ai,i|
      (1..word.length - i).inject(ai){|aj,j|
        aj << word[i,j]
      }
    }.uniq
  end
end
