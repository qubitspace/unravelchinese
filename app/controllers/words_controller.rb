class WordsController < ApplicationController
  include Concerns::Manageable

  def index
    authorize Word
    if params[:query].present?
      @results = Word.search(params[:query], params[:exact_match])
    elsif params[:simplified].present?
       @results = Word.find_word(params[:simplified], params[:traditional], params[:pinyin])
    else
      @results = Word.none
    end
  end

  def show
    @word = policy_scope(Word).find(params[:id])
    authorize @word

    @derived_words = Word.order('-hsk_character_level desc')
      .search(@word.simplified).select { |word| word != @word }
      .first(5)
    @sub_words = Word.order('-hsk_character_level desc')
      .where(simplified: split_word(@word.simplified))
      .select { |word| word != @word }
      .first(5)
    @synonyms = Word.where(pinyin: @word.pinyin).select { |word| word != @word }.first(5)
    @sentences = Sentence.where(['value LIKE ?', "%#{@word.simplified}%"]).first(5)
    if @sentence.present?
      @articles = @sentences.collect { |sentence| sentence.section.present? and sentence.section.article.present? }
        .uniq{ |article| article.id }
        .first(5)
    end
  end

  def manage
    @word = Word.find(params[:word_id])
    authorize @word

    @definition_form = Definition::Form.new(Definition.new)
    @tag_form = Tag::Form.new(Tag.new)
  end

  def update_status
    @word = policy_scope(Word).find(params[:word_id])
    authorize @word

    learned_word = LearnedWord.find_or_create_by(user: current_user, word: @word)
    learned_word.status = params[:status]

    if LearnedWord.allowed_statuses.include? params[:status]
      learned_word.save
    else
      learned_word.destroy
    end

    render js:
      concept("word/word_cell/show", @word, current_user: current_user).(:refresh) +
      concept("word/word_cell/list", @word, current_user: current_user).(:refresh) +
      concept("word/word_cell/manage", @word, current_user: current_user).(:refresh) +
      concept("word/word_cell/inline", @word, current_user: current_user).(:refresh) +
      concept("word/word_cell/search", @word, current_user: current_user, query: params[:query]).(:refresh)

  end

  def split_word word
    authorize Word
    (0..word.length).inject([]){|ai,i|
      (1..word.length - i).inject(ai){|aj,j|
        aj << word[i,j]
      }
    }.uniq
  end

  def create_definition
    @word = Word.find params[:word_id]
    authorize @word

    @form = Definition::Form.new(Definition.new(:word_id => @word.id))

    if @form.validate(params[:definition])
      @form.sync
      @definition = @form.model

      @form.save do |form|
        @definition.set_sort_order @word, form[:sort_order]
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
    authorize Word

    # Shouldn't this be in the definitions controller?
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
    authorize Word

    @definition = Definition.find(params[:definition_id])
    @definition.destroy

    respond_to :js
  end

  def show_edit_definition_form
    authorize Word

    @definition = Definition.includes(:word).find(params[:definition_id])
    @form = Definition::Form.new(@definition)
    respond_to :js
  end

  def show_manage_definition_cell
    authorize Word

    @definition = Definition.find(params[:definition_id])
    respond_to :js
  end

  def process_params!(params)
    authorize Word

    params.merge!(current_user: current_user)
  end


end
