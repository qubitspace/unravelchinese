class SentencesController < ApplicationController

  def index
    @sentences = Sentence.all
  end

  def show
    @sentence = get_sentence params[:id]#Sentence.find params[:id]
  end

  def new
    @form = Sentence::Form.new(Sentence.new)
  end

  # def create
  #   run Sentence::Create do |op|
  #     flash[:notice] = "Created sentence for \"#{op.sentence.name}\""
  #     return redirect_to article_path(@article)
  #   end
  #   @article = Article.find(params[:article_id])
  #   render :new
  # end


  def create
    @article = Article.find params[:sentence][:article_id]

    sentence = Sentence.new(:article_id => @article.id)
    sentence.translations.build(source: Source.new)

    @form = Sentence::Form.new(sentence)

    if @form.validate(params[:sentence])
      @form.sync
      @sentence = @form.model

      @form.save do |form|
        translation_form = form[:translations][0]
        translation = @sentence.translations[0]

        if translation_form[:source_id].present?
          translation.source = Source.find(translation_form[:source_id])
        else
          translation.source.update_attributes translation_form[:source]
        end
        @sentence.save
      end

      flash[:notice] = "Created sentence for \"#{@article.title}\""
      respond_to do |format|
        @sentence = Sentence.new
        @sentence.translations.build
        @new_form = Sentence::Form.new(@sentence)
        format.js   { render :action => "show_new_sentence"}
      end
    else
      respond_to do |format|
        format.js   { render :action => "refresh_new_form"}
      end
    end
  end

  # def destroy
  #   @sentence = Sentence.find params[:id]
  #   @sentence.destroy

  #   redirect_to [:admin, @sentence.article]
  # end

  def manage
    @sentence = get_sentence params[:sentence_id]#Sentence.find params[:sentence_id]

    @sentence.untokenized = @sentence.value.dup
    @sentence.tokens.each do |token|
      @sentence.untokenized.slice! token.word.simplified
    end

    @words = Word.all
    @candidate_tokens = get_candidate_tokens @sentence.untokenized
  end

  def add_token
    @sentence = get_sentence params[:sentence_id]#Sentence.find params[:sentence_id]
    word = Word.find params[:word_id]

    @sentence.untokenized = @sentence.value.dup
    @sentence.tokens.each do |token|
      @sentence.untokenized.slice! token.word.simplified
    end

    if @sentence.untokenized.present? or @sentence.untokenized =~ /^#{word.simplified}/
      token_rank = @sentence.tokens.size == 0 ? 0 : @sentence.tokens.map(&:rank).max + 1
      token = Token.create sentence: @sentence, word: word, rank: token_rank
      @sentence.reload
      @sentence.untokenized.slice! token.word.simplified
      @candidate_tokens = get_candidate_tokens @sentence.untokenized

      render js: concept("sentence/sentence_cell/tokenize_sentence_cell", @sentence, candidate_tokens: @candidate_tokens, current_user: current_user).(:refresh)
    else
      @candidate_tokens = get_candidate_tokens @sentence.untokenized
      flash[:alert] = "Error adding token. Token word didn't match untokenized text."
      render js: "window.location = '#{tokenize_sentence_path(@sentence)}'"
      return
    end

  end

  # def copy_text
  #   sentence = Sentence.find params[:sentence_id]
  #   @text = sentence.value

  #   respond_to do |format|
  #     format.js
  #   end
  # end

  # def update_word_status
  #   @word = Word.find(params[:word_id])
  #   @word.update_status current_user, params[:status]

  #   @sentence = Article.find(params[:sentence_id])
  #   #@stats = @sentence.get_stats current_user

  #   respond_to do |format|
  #     format.js
  #   end
  # end



  # def untokenize
  #   @sentence = Sentence.find params[:id]
  #   @sentence.tokens.delete_all
  #   redirect_to manage_admin_sentence_path(@sentence)
  # end


  private

  def get_candidate_tokens untokenized

    matches = []
    return matches unless untokenized.present?

    potential_matches = untokenized.empty? ? [] : Word.where("simplified LIKE :prefix", prefix: "#{untokenized[0]}%")
    potential_matches.each do |word|
      matches << word if word.simplified == untokenized[0...word.simplified.length]
    end
    if matches.empty?
      if untokenized[/^([a-zA-Z0-9_.-]*)/,1].length > 0
        word = Word.find_or_create_by simplified: untokenized[/^([a-zA-Z0-9_.-]*)/,1], category: :alphanumeric
      else
        word = Word.find_or_create_by simplified: untokenized[0], category: :alphanumeric
      end
      matches << word
    end
    return matches.sort_by { |y| -y.simplified.length} # TODO: add sort by how often it's used in the site.
  end

  def get_sentence id
    Sentence.includes(
      { words: [:definitions] },
      :source
    ).find(id)
  end

  def get_word id
    Word.includes(:definitions).find(id)
  end
end
