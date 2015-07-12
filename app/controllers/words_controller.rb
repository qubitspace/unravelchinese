class WordsController < ApplicationController

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
    @definition_form = Definition::Form.new(Definition.new)
  end


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
      concept("word/word_cell", @word, current_user: current_user).(:refresh) +
      concept("word/word_cell/word_preview_cell", @word, current_user: current_user).(:refresh) +
      concept("word/word_cell/word_search_result_cell", @word, current_user: current_user, query: params[:query]).(:refresh) +
      concept("word/word_cell/word_manage_cell", @word, current_user: current_user, query: params[:query]).(:refresh)

    # add logic to check if the update suceeded and if it failed, then javascript to say failure.
  end

  def split_word word
    (0..word.length).inject([]){|ai,i|
      (1..word.length - i).inject(ai){|aj,j|
        aj << word[i,j]
      }
    }.uniq
  end


  def create_definition
    @word = Word.find params[:word_id]
    @form = Definition::Form.new(Definition.new(:word_id => @word.id))

    if @form.validate(params[:definition])
      @form.sync
      @definition = @form.model

      @form.save do |form|
        @definition.set_rank @word, form[:rank]
        @definition.save
      end
      flash[:notice] = "Created definition for \"#{@word.simplified}\""
      respond_to do |format|
        @new_form = Definition::Form.new(Definition.new(:word_id => @word.id))
        format.js { render :action => "show_new_definition" }
      end
    else
      respond_to do |format|
        format.js   { render :action => "show_new_definition_form" }
      end
    end
  end


  def update_definition
    @definition = Definition.find(params[:definition][:id])
    @form = Definition::Form.new(@definition)

    success = false
    if @form.validate(params[:definition])
      @form.save
      success = true
    end

    if success
      respond_to do |format|
        format.js   { render :action => "show_manage_definition_cell"}
      end
    else
      respond_to do |format|
        format.js   { render :action => "show_edit_definition_form"}
      end
    end
  end

  def delete_definition
    @definition = Definition.find(params[:definition_id])
    @definition.destroy

    respond_to :js
  end

  def show_edit_definition_form
    @definition = Definition.includes(:word).find(params[:definition_id])
    @form = Definition::Form.new(@definition)
    respond_to :js
  end

  def show_manage_definition_cell
    @definition = Definition.find(params[:definition_id])
    respond_to :js
  end

  def untag
    byebug
    word = Word.find(params[:taggable_id])
    @tagging = Tagging.find(params[:tagging_id])
    @tagging.destroy #TODO: if success remove, otherwise show error

    respond_to do |format|
      format.js { render :action => "remove_tagging"}
    end
  end

  private


  def process_params!(params)
    params.merge!(current_user: current_user)
  end

end
