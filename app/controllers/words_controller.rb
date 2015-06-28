class WordsController < ApplicationController

  def update_status
    @word = Word.find(params[:word_id])

    learned_word = LearnedWord.find_or_create_by(user: current_user, word: @word)
    learned_word.status = params[:status]

    if ['known', 'learning'].include? params[:status]
      learned_word.save
    else
      learned_word.destroy
    end

    render js:
      concept("word/cell", @word, current_user: current_user).(:refresh) +
      concept("word/cell/preview", @word, current_user: current_user).(:refresh) +
      concept("word/cell/search_result", @word, current_user: current_user, query: params[:query]).(:refresh)

    # add logic to check if the update suceeded and if it failed, then javascript to say failure.
  end

  def index
    if params[:query].present?
      @results = Word.search(params[:query], params[:match_accents])
    elsif params[:simplified].present?
       @results = Word.find_word(params[:simplified], params[:traditional], params[:pinyin])
    else
      @results = Word.none
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

  def new
    @form = Word::Form.new(Word.new)
  end

  def create

  end

  def edit
    @form = Word::Form.new(Word.find(params[:id]))
  end

  def update
    @word = Word.find(params[:id])
    @form = Word::Form.new(@word)

    if @form.validate(params[:word])
      @form.save
      return redirect_to word_manage_path(@word)
    end
    render :edit
  end

  def manage
    @word = Word.find(params[:word_id])
    @form = Definition::Form.new(Definition.new)
  end


  def create_definition
    @word = Word.find params[:word_id]
    @form = Definition::Form.new(Definition.new)
    @form.word = @word
    if @form.validate(params[:definition])
      @form.sync
      definition = @form.model

      @form.save do |form|
        definition.set_rank @word, form[:rank]
        definition.save
      end
      flash[:notice] = "Created definition for \"#{@word.simplified}\""
      return redirect_to word_manage_path(@word)
    end

    render :manage
  end

  def split_word word
    (0..word.length).inject([]){|ai,i|
      (1..word.length - i).inject(ai){|aj,j|
        aj << word[i,j]
      }
    }.uniq
  end

  private

  def process_params!(params)
    params.merge!(current_user: current_user)
  end

end
